{ pkgs
, config
, abs
, lib
, ...
}:
let
  secrets = import (abs "lib/secrets.nix");
in
{
  imports = [
    (secrets.declare [ "noreply-password" "mediawiki-db-password" "mediawiki-admin-password" ])
    {

      age.secrets.mediawiki-db-password.owner = "mediawiki";
      age.secrets.mediawiki-db-password.group = config.services.nginx.group;
      age.secrets.mediawiki-admin-password.owner = "mediawiki";
      age.secrets.mediawiki-admin-password.group = config.services.nginx.group;
      age.secrets.noreply-password.owner = "mediawiki";
      age.secrets.noreply-password.group = config.services.nginx.group;
    }
    ./nginx.nix
  ];
  services.mediawiki = {
    enable = true;
    name = "MURS вики";
    url = "https://wiki.murs-mc.ru";
    passwordFile = config.age.secrets.mediawiki-admin-password.path;
    webserver = "nginx";

    nginx = {
      hostName = "wiki.murs-mc.ru";
    };
    database.createLocally = false;
    database.passwordFile = config.age.secrets.mediawiki-db-password.path;
    skins = {
      MinervaNeue = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/skins/MinervaNeue-REL1_41-68e98df.tar.gz";
        hash = "sha256-yIZB84K7hawTTu6cblRZqlyJ4vymJqx9TtlLMn2gLSA=";
      };
    };
    extensions = {
      # bundled extensions
      CategoryTree = null;
      Cite = null;
      CiteThisPage = null;
      CodeEditor = null;
      Echo = null;
      Gadgets = null;
      ImageMap = null;
      InputBox = null;
      Interwiki = null;
      Linter = null;
      LoginNotify = null;
      Math = null;
      MultimediaViewer = null;
      Nuke = null;
      OATHAuth = null;
      PageImages = null;
      ParserFunctions = null;
      Poem = null;
      ReplaceText = null;
      Scribunto = null;
      SecureLinkFixer = null;
      SpamBlacklist = null;
      SyntaxHighlight_GeSHi = null;
      TemplateData = null;
      TextExtracts = null;
      Thanks = null;
      TitleBlacklist = null;
      VisualEditor = null;
      WikiEditor = null;
      PdfHandler = null;

      TemplateStyles = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_41-a9dde29.tar.gz";
        hash = "sha256-pp7xpb9Zco1P8OdEAd61MSn2PlrQY0Zc1o/gmaKF4zs=";
      };

      CodeMirror = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_41-f833cc4.tar.gz";
        hash = "sha256-Rg6ua5trCDuCSh3jLzrUhIxZXEKiTo5htrUprNAAV68=";
      };

      CreatePage = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/CreatePage-REL1_41-9bbb7a7.tar.gz";
        hash = "sha256-qHVEOO9tc17cX1b7Qd1zXaVDrxEwkJJ0owQrUSEvuOo=";
      };

      PageViewInfo = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/PageViewInfo-REL1_41-86cdaa5.tar.gz";
        hash = "sha256-pK80KApB81U9GVS7nwk7zM7n3T0aGjNGVE6QifEgNVo=";
      };

      MobileFrontend = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_41-c66ff31.tar.gz";
        hash = "sha256-LGYB4zmf8a7NoFQbel0/86jzZzCBZRHwU1j2J5i/MVU=";
      };

      Moderation = pkgs.fetchgit {
        url = "https://github.com/edwardspec/mediawiki-moderation.git";
        hash = "sha256-fGzNzG+yIdgPgEpqDLAVb0siTtpOzcsLuYDFY07r4vM=";
      };

      Spoilers = pkgs.fetchgit {
        url = "https://github.com/Telshin/Spoilers.git";
        hash = "sha256-qpMYYNjnolj5yWYyOAfuTL6CvL4lZzqx3FuNtWcjKT8=";
      };

      Purge = pkgs.fetchgit {
        url = "https://github.com/AlPha5130/mediawiki-extensions-Purge.git";
        hash = "sha256-81Q5tQvgCKFUw3Vqfp++2S5NLjIjxuinUxVr9Jno6wo=";
      };
    };
    extraConfig = ''
      $wgMainCacheType = CACHE_ACCEL;

      $wgMetaNamespace = "MURS";

      $wgLogos = [
        '1x' => "/w/images/thumb/5/5a/MURS_Blue_logo_with_background.png/155px-MURS_Blue_logo_with_background.png",		// path to 1x version
        'icon' => "/w/images/thumb/5/5a/MURS_Blue_logo_with_background.png/155px-MURS_Blue_logo_with_background.png",			// A version of the logo without wordmark and tagline
        'wordmark' => [
          'src' => "/w/images/1/1d/Вики_MURS.png",	// path to wordmark version
          'width' => 130,
          'height' => 19,
        ],
      ];
      $wgFavicon = "/w/images/thumb/5/5a/MURS_Blue_logo_with_background.png/155px-MURS_Blue_logo_with_background.png";
      $wgLanguageCode = "ru";
      $wgEnableEmail = true;
      $wgSMTP = [
        'host'      => 'srv04.murs-mc.ru',                                              // could also be an IP address. Where the SMTP server is located. If using SSL or TLS, add the prefix "ssl://" or "tls://".
        'IDHost'    => 'wiki.murs-mc.ru',                                               // Generally this will be the domain name of your website (aka mywiki.org)
        'localhost' => 'wiki.murs-mc.ru',                                               // Same as IDHost above; required by some mail servers
        'port'      => 587,                                                             // Port to use when connecting to the SMTP server
        'auth'      => true,                                                            // Should we use SMTP authentication (true or false)
        'username'  => 'noreply@murs-mc.ru',                                            // Username to use for SMTP authentication (if being used)
        'password'  => file_get_contents("${config.age.secrets.noreply-password.path}") // Password to use for SMTP authentication (if being used)
      ];
      $wgEmergencyContact = "weryskok@murs-mc.ru";
      $wgPasswordSender = "noreply@murs-mc.ru";
      #$wgShowExceptionDetails = true;
      $wgGroupPermissions['sysop']['interwiki'] = true;
      $wgScribuntoDefaultEngine = 'luastandalone'; # TODO: maybe luasandbox would be better but idk
      $wgScribuntoEngineConf['luastandalone']['luaPath'] = '${pkgs.lua5_1}/bin/lua';

      # InstantCommons allows wiki to use images from https://commons.wikimedia.org
      $wgUseInstantCommons = true;

      $wgAllowUserCss = true;
      $wgAllowUserJs = true;

      $wgDefaultMobileSkin = 'minerva';
      $wgMinervaShowCategories['base'] = true;

      $wgImageMagickConvertCommand  = '${pkgs.imagemagick}/bin/convert';

      $wgSVGConverterPath = '${pkgs.imagemagick}/bin';
      $wgSVGConverter = 'ImageMagick';
      $wgFileExtensions[] = 'svg';

      $wgFileExtensions[] = 'pdf';
      $wgPdfProcessor = '${pkgs.ghostscript}/bin/gs';
      $wgPdfPostProcessor = $wgImageMagickConvertCommand;
      $wgPdfInfo = '${pkgs.poppler_utils}/bin/pdfinfo';
      $wgPdftoText = '${pkgs.poppler_utils}/bin/pdftotext';
    '';
  };

  services.phpfpm.pools.mediawiki =
    {
      phpPackage = lib.mkForce (pkgs.php81.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          apcu
        ]));
      });

      settings = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = lib.mkForce 5;
      };

      phpOptions = ''
        upload_max_filesize = 150M
        post_max_size = 200M
      '';
    };

  services.nginx.virtualHosts.${config.services.mediawiki.nginx.hostName} = {
    forceSSL = true;
    sslCertificate = config.age.secrets.cf-origin-public-cert.path;
    sslCertificateKey = config.age.secrets.cf-origin-private-cert.path;
    extraConfig = ''
      client_max_body_size 250M;
    '';
  };
}
