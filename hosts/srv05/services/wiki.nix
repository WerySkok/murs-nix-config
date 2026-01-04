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
        name = "MinervaNeue";
        url = "https://extdist.wmflabs.org/dist/skins/MinervaNeue-REL1_45-3d5769e.tar.gz";
        hash = "sha256-eGBa5i/xH6iiyPImdR7WGC5cenbZter6duvMfVFzFI8=";
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
        name = "TemplateStyles";
        url = "https://extdist.wmflabs.org/dist/extensions/TemplateStyles-REL1_45-f1b7898.tar.gz";
        hash = "sha256-DJz01SpIqv8mDYSI7V3DyvaNys78JzK/VFC3r6mfWZc=";
      };

      CodeMirror = pkgs.fetchzip {
        name = "CodeMirror";
        url = "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_45-2242dd5.tar.gz";
        hash = "sha256-WpJrj3Ye+AmK5FkfKHQh8ZLIQtLDFXXtVEBCVKkdshE=";
      };

      CreatePage = pkgs.fetchzip {
        name = "CreatePage";
        url = "https://extdist.wmflabs.org/dist/extensions/CreatePage-REL1_45-cc13a6c.tar.gz";
        hash = "sha256-D1cqm5kv6V5YJBeTT51Ij7x+PTxigncggzDtf590Lk0=";
      };

      PageViewInfo = pkgs.fetchzip {
        # TODO: приплести аналитику
        name = "PageViewInfo";
        url = "https://extdist.wmflabs.org/dist/extensions/PageViewInfo-REL1_45-bd10471.tar.gz";
        hash = "sha256-rG7zv3ZXbnFSMGxnWw5uao060LcZG/z4Bhutnr4wax0=";
      };

      MobileFrontend = pkgs.fetchzip {
        name = "MobileFrontend";
        url = "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_45-2bccb7e.tar.gz";
        hash = "sha256-plQ5hgFO3k/Pz8TAigx3vT3aW+ZtyvM6Vv1lCUbfVCE=";
      };

      Moderation = pkgs.fetchgit {
        url = "https://github.com/edwardspec/mediawiki-moderation.git";
        hash = "sha256-ioWVaI5uw2fKipsXbPiImonv4kqjh2dYgXamDv1Kx7g=";
      };

      Spoilers = pkgs.fetchgit {
        url = "https://github.com/Telshin/Spoilers.git";
        hash = "sha256-e+ZgMppe4jzobvXvuHScP7ntajB2LFshIpsW5dmaSDk=";
      };

      Purge = pkgs.fetchgit {
        url = "https://github.com/AlPha5130/mediawiki-extensions-Purge.git";
        hash = "sha256-Jn1AcoKeFFp3P9k4dw+vO+8w5pHAsV7pHMYPo9AWsZY=";
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
        'host'      => 'srv05.murs-mc.ru',                                              // could also be an IP address. Where the SMTP server is located. If using SSL or TLS, add the prefix "ssl://" or "tls://".
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
      $wgPdfInfo = '${pkgs.poppler-utils}/bin/pdfinfo';
      $wgPdftoText = '${pkgs.poppler-utils}/bin/pdftotext';
    '';
  };

  services.phpfpm.pools.mediawiki =
    {
      phpPackage = lib.mkForce (pkgs.php82.buildEnv {
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
    enableACME = true;
    extraConfig = ''
      client_max_body_size 250M;
    '';
  };
}
