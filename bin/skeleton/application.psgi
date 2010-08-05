#!/usr/bin/perl

use strict;

use lib ("../mods");

# XXX replace these with appropriate values
my $root = "../";

use AnyEvent::Impl::EV;
use Madrone;
use Madrone::Parser;
use Plack::Builder;
use Plack::Request;
use Plack::Response;
use HTTP::Exception;

our $templates = Madrone::parseDirectory("$root/templates", "$root/mods");

my $app = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);

    my $context = {req=>$req};
    my $template;

    # XXX map requests to templates
    if ($req->path_info eq '/') {
        $template = "index";
    } elsif ($req->path_info eq '/post') {
        $template = "post";
    } else {
        my $res = Plack::Response->new(404);
        return $res->finalize;
    }

    return sub {
        my $respond = shift;

        # here is the call into madrone
        $templates->{ $template }->walk($context, {}, sub {
            my $data = shift;

            utf8::encode($data);

            my $len = length($data);
            my $res = Plack::Response->new(200);
            $res->content_type("text/html");
            $res->content_length($len);
            $res->body($data);
            my $out = $res->finalize;
            $respond->($out);
        });

    };
};

builder {
    enable "Plack::Middleware::Static",
           path => qr{^/static/}, root => "$root";
    enable "Plack::Middleware::Static",
           path => qr{^/js/}, root => "$root/static";
    enable "Plack::Middleware::Static",
           path => qr{^/css/}, root => "$root/static";

    # XXX exception handling

    # default in plackup development mode
    enable "StreamingStackTrace";
    # default in plackup 'production' mode
    #enable "HTTPExceptions";

    $app;
}
