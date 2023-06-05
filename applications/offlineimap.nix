{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [

    (offlineimap.overrideAttrs (oldAttrs: rec {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ python3.pkgs.keyring ];
    }))

  ];

  xdg.configFile = {
    "offlineimap" = {
      target = "offlineimap/config";
      text = ''
        [general]
        accounts = personal,school
        pythonfile = ${config.home.homeDirectory}/${config.xdg.configFile.offlineimap-py.target}
        
        [Account personal]
        localrepository = personal-local
        remoterepository = personal-remote
        
        [Account school]
        localrepository = school-local
        remoterepository = school-remote
        
        [Repository personal-local]
        type = Maildir
        localfolders = ~/mail
        nametrans = lambda folder: re.sub('^personal$', 'INBOX', folder)
        
        [Repository school-local]
        type = Maildir
        localfolders = ~/mail
        nametrans = lambda folder: re.sub('^school$', 'INBOX', folder)
        
        [Repository personal-remote]
        type = IMAP
        sslcacertfile = /etc/ssl/certs/ca-certificates.crt
        remotehosteval = keyring.get_password("offlineimap", "personal-host")
        remoteusereval = keyring.get_password("offlineimap", "personal-user")
        remotepasseval = keyring.get_password("offlineimap", "personal")
        folderfilter = lambda foldername: foldername in ['INBOX']
        nametrans = lambda folder: re.sub('^INBOX$', 'personal', folder)
        
        [Repository school-remote]
        type = Gmail
        sslcacertfile = /etc/ssl/certs/ca-certificates.crt
        ssl_version = tls1_2
        remoteusereval = keyring.get_password("offlineimap", "school-user")
        remotepasseval = keyring.get_password("offlineimap", "school")
        nametrans = lambda folder: re.sub('^INBOX$', 'school', folder)
        folderfilter = lambda foldername: foldername in ['INBOX']
      '';
    };
    "offlineimap-py" = {
      target = "offlineimap/offlineimap.py";
      text = ''
        import keyring
      '';
    };
  };
  
}
