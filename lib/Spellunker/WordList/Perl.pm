package Spellunker::WordList::Perl;
use strict;
use warnings;
use utf8;

# Perl/CPAN/Computer specific word list.

sub load_word_list {
    my @tech_words = qw(
        https
        C
        gmail
        FAQ
        URL
        http
        perl
        ftp
        gopher
        php
        de facto
        picohttpparser
        gzip
        DNS
        TCP
        TODO
        OSX
        XP
        homebrew
        svn
        gitignore
        CVS
        RT
        val
        O'Reilly
        'em
        mod_perl
    );
    my @web_service_name = qw(
        lingr
        gmail
    );
    my @perl_words = qw(
        CPANfile
        cpanfile
        Minilla
        mymeta
        PL
        blib
        perlbrew
        cpanm
        plenv
        undef
        path_query
        no_proxy
        max_redirects
        Perl5
        cookie_jar
        Spellunker
        XS
        Furl
        LWP
        AnyEvent
        AOP
        API
        AspectJ
        Babelfish
        CamelCase
        Coro
        CPAN
        CPANPLUS
        DateTime
        DBI
        Django
        DSL
        EINTR
        EPP
        Firefox
        FirePHP
        FIXME
        GraphViz
        GUID
        GUIDs
        HTTP
        HTTPS
        IETF
        IP
        IPv4
        IPv6
        IRC
        ISP
        ISP's
        JSON
        MakeMaker
        Markdown
        Middleware
        MongoDB
        mkdn
        modulino
        MVC
        OO
        OOP
        PARC
        PHP
        Plack
        PSGI
        RDBMS
        README
        ShipIt
        SMTP
        Spiffy
        SQL
        SQLite
        SSL
        STDERR
        STDIN
        STDOUT
        svk
        TIMTOWTDI
        Unicode
        URI
        URI's
        URIs
        UTC
        UTF
        UUID
        UUIDs
        W3CDTF
        wiki
        XS
        YAML
        YAML's
        sysopen
    );
    my @stop_words = qw(
        adaptee
        adaptees
        administrativa
        afterwards
        aggregator
        aggregators
        analyses
        array's
        backend
        behaviour
        benchmarked
        blog
        blogs
        breakpoint
        breakpoints
        bugtracker
        bundle's
        callback
        callbacks
        callee
        chomp
        chomps
        chunked
        configurator
        configurators
        crosscutting
        debugger's
        denormalized
        deserialized
        distname
        dotfile
        dotfiles
        filename
        filenames
        formatter
        github
        hash's
        homepage
        hostname
        indices
        init
        iteratively
        japanese
        Joseki
        kwalitee
        locator
        lookup
        lookups
        marshalling
        metadata
        middleware
        mixin
        monkeypatch
        monkeypatches
        monkeypatching
        multi
        multi-value
        multi-valued
        munge
        munger
        munging
        namespace
        namespaces
        nestable
        ok
        op
        parameterizable
        pipe's
        placeholders
        pluggable
        plugin's
        plugins
        pointcut
        pointcuts
        pre
        precompute
        precomputes
        prepends
        preprocessed
        prereq
        prereqs
        probe's
        redirections
        redispatch
        ref
        reusability
        runtime
        san
        searchable
        seekable
        segment's
        shipit
        sigils
        startup
        stopword
        stopwords
        storable
        storages
        stringification
        stringifications
        stringifies
        stringify
        subclass
        subclasses
        subdirectories
        subdirectory
        subobjects
        symlinked
        terminal's
        timestamp
        tokenizes
        toolchain
        tuple
        unblessed
        unshifts
        username
        uuid
        value's
        variable's
        vim
        wellformedness
        whitelist
        whitelists
        workflow
        workflows
        wormhole
        yml
    );
    my @moose_words = qw(
        Str
        Int
        FileHandle
        ArrayRef
        HashRef
        CodeRef
    );
    my @authors = qw(
        Achim
        Adam
        Cushing
        Damian Conway
        Dan Kogai
        Doherty
        Doran
        Eilam
        Ekker
        Florian
        Goro Fuji
        Heinz
        Helmberger
        Hofstetter
        Kazuho Oku
        Lapworth
        Marcel Gruenauer
        Mark
        Metheringham
        Ran
        Ricardo Signes rjbs
        Takesako
        Tatsuhiko Miyagawa
        Tokuhiro Matsuno
        audreyt
        dankogai
        gfx
        lestrrat
        mala
        mattn
        mst
        tokuhirom
        walf443
    );
    my @misc_words = qw(
        perl
        USA
accessor
Apache2
apps
arrayref
autoload
backends
basename
bobtfish
boolean
clkao
COMPATIBLITY
conf
config
Ctrl+C
daemonize
dereference
eval
ExternalServer
fastcgi
FastCGI
fcgi
filehandle
filesystem
foreach
frontend
frontends
haarg
harakiri
HARAKIRI
hiratara
httpexceptions
IIS6
IIS7
inline
INLINE
interace
JSONP
KnowZeroX
lifecycle
LIFECYCLE
lighttpd
loadable
localhost
Log4perl
LogDispatch
middlewares
miyagawa
MobileDetector
MockHTTP
multiprocess
nginx
nointr
nopaste
nothingmuch
nproc
NullLogger
param
PerlIO
plackup
prefork
preforking
PREFORKING
preload
preloaded
preloading
prepended
proc
proxied
psgi
psgix
rackup
rafl
reqs
rethrown
runnable
sendfile
SimpleLogger
stacktrace
standalone
stderr
subrequest
toolkit
typester
umask
URLMap
URLs
uWSGI
webserver
    );
    return (@tech_words, @moose_words, @web_service_name, @perl_words, @authors, @misc_words, @stop_words);
}

1;

