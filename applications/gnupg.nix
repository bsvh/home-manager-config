{ inputs, outputs, lib, config, pkgs, ... }:
{
  home.file."gpg.conf" = {
    target = ".gnupg/gpg.conf";
    text = ''
      cert-digest-algo SHA512
      charset utf-8
      default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
      fixed-list-mode
      keyid-format 0xlong
      list-options show-uid-validity
      no-comments
      no-emit-version
      no-greeting
      no-symkey-cache
      personal-cipher-preferences AES256 AES192 AES
      personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
      personal-digest-preferences SHA512 SHA384 SHA256
      require-cross-certification
      s2k-cipher-algo AES256
      s2k-digest-algo SHA512
      use-agent
      verify-options show-uid-validity
      with-fingerprint
    '';
  };
  home.file."gpg-agent.conf" = {
    target = ".gnupg/gpg-agent.conf";
    text = ''
      pinentry-program /usr/bin/pinentry-gnome3
      default-cache-ttl 60
      max-cache-ttl 120
    '';
  };
  home.file."scdaemon.conf" = {
    target = ".gnupg/scdaemon.conf";
    text = ''
      pcsc-shared
      card-timeout 5
    '';
  };
  home.file."pubkey-ed25519" = {
    target = ".gnupg/pubkey-ed25519.asc";
    onChange = "/usr/bin/gpg --import ${config.home.file.pubkey-ed25519.target}";
    text = ''
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      
      mDMEZHtXZhYJKwYBBAHaRw8BAQdA5DTnBIcVHNMJLChUlqhxU6iPAZtREvZMHhjk
      9D6XAcW0MkJyZW5kYW4gVmFuIEhvb2sgPGJyZW5kYW5AdmFzdGFjdGl2ZS5jb20+
      IChMYXB0b3ApiI4EExYKADYWIQRT/8ntIyxZyZBgrH2m8vJlbS0rcAUCZHtXZgIb
      AQQLCQgHBBUKCQgFFgIDAQACHgUCF4AACgkQpvLyZW0tK3BlDAD+LYNW0US1f30s
      M9MX8HRTEWGdggRqPCHS6GLI9n3sMaIBAKRzuPRpkUoWi4NynQDlfN+lzp4i0zMP
      wuYfuvgeX4oKuDMEZHtXzRYJKwYBBAHaRw8BAQdAKoIqdE1tmuwGZCGekuRiw5Df
      Rs6pjuN0iVfEoHVZPJCI9QQYFgoAJhYhBFP/ye0jLFnJkGCsfaby8mVtLStwBQJk
      e1fNAhsCBQkB4TOAAIEJEKby8mVtLStwdiAEGRYKAB0WIQTZTkV0JWx0b++4mxTg
      A4IlvTLsnQUCZHtXzQAKCRDgA4IlvTLsnaVgAPoDFu0FS9FUFYAftpNk0beJJ8su
      K5k8L9YBa3Cl+9gTkwEA2+dSixGJvW99aLc3LzC/0jbxZ7l8bGXls8OPdc2U3gDs
      tAD8CPdfVJPirsFusU2zeiW1d5GjKOcJFV6Y8YfEQo5WnIwBANcUkhoNDYwJwNCA
      /uE/UdClUjlrhbMgq4td9fVzH+MAuDgEZHtX9BIKKwYBBAGXVQEFAQEHQMhpLVmi
      0KQ5lmK+FnJFlJM3weVMnkReFE+vjH3mGnQ7AwEIB4h+BBgWCgAmFiEEU//J7SMs
      WcmQYKx9pvLyZW0tK3AFAmR7V/QCGwwFCQHhM4AACgkQpvLyZW0tK3BYngD/S8+6
      vUQAob6gZvmDCjMgVCjKG9F9stY3Fr+2t9dQwsUBALdH/4CWLhzkJKiHWgzpPasQ
      Gli9zI+iokDqupXhyBsEuDMEZHtYAhYJKwYBBAHaRw8BAQdA8ETV32TpAhQXZGIF
      AYHA1Nii46DdkqD35ID/eyT+ODWIfgQYFgoAJhYhBFP/ye0jLFnJkGCsfaby8mVt
      LStwBQJke1gCAhsgBQkB4TOAAAoJEKby8mVtLStwepQBAOGlrwIo1n09Dkpnbqlv
      dLcHzcv5yHqQSTaG32/UcZp1AP0QJw64V2U34aB8d68BRciKk4xNNCaeeq2N+K5P
      o2c4Bg==
      =uj9G
      -----END PGP PUBLIC KEY BLOCK-----
    '';
  };
  home.file."pubkey-sha" = {
    target = ".gnupg/pubkey-sha.asc";
    onChange = "/usr/bin/gpg --import ${config.home.file.pubkey-ed25519.target}";
    text = ''
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      
      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
      c2kb4JNvTaPddo8=
      =Z49c
      -----END PGP PUBLIC KEY BLOCK-----
    '';
  };
}
