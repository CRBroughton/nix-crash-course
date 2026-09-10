{ pkgs, ... }:
{
  packages = [
    pkgs.git
  ];

  languages.python.enable = true;

  services = {
    # https://devenv.sh/services/postgres/
    postgres = {
      enable = true;
      listen_addresses = "127.0.0.1";
      initialDatabases = [ { name = "app"; } ];
    };

    # https://devenv.sh/services/redis/
    redis.enable = true;
  };

  git-hooks.hooks = {
    nixfmt.enable = true;
    statix.enable = true;
    deadnix.enable = true;
  };

  scripts.db-query = {
    exec = ''
      if ! pg_isready -h 127.0.0.1 --timeout=2 >/dev/null 2>&1; then
        devenv up -d
        pg_isready -h 127.0.0.1 --timeout=30
      fi
      psql -h 127.0.0.1 -d app -c "SELECT current_database();"
      redis-cli ping
    '';
    description = "Check Postgres and Redis";
  };

  enterShell = ''
    echo "devenv is ready"
    echo "  devenv up -d   # start Postgres and Redis in the background"
    echo "  db-query       # ping both services"
  '';

  enterTest = ''
    pg_isready -h 127.0.0.1 --timeout=30
    redis-cli ping
    psql -h 127.0.0.1 -d app -c "SELECT current_database();"
  '';
}
