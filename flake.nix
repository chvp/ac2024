{
  description = "Advent of Code 2024";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, devshell, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlays.default ]; };
      in
      {
        devShells = rec {
          default = accentor-api;
          accentor-api = pkgs.devshell.mkShell {
            name = "Advent of Code 2024";
            packages = [
              pkgs.nixpkgs-fmt
              pkgs.postgresql_14
            ];
            env = [
              {
                name = "PGDATA";
                eval = "$PRJ_DATA_DIR/postgres";
              }
              {
                name = "DATABASE_HOST";
                eval = "$PGDATA";
              }
            ];
            commands = [
              {
                name = "pg:setup";
                category = "database";
                help = "Setup postgres in project folder";
                command = ''
                  initdb --encoding=UTF8 --no-locale --no-instructions -U postgres
                  echo "listen_addresses = ${"'"}${"'"}" >> $PGDATA/postgresql.conf
                  echo "unix_socket_directories = '$PGDATA'" >> $PGDATA/postgresql.conf
                  echo "CREATE USER aoc2024 WITH PASSWORD 'aoc2024' CREATEDB;" | postgres --single -E postgres
                '';
              }
              {
                name = "pg:start";
                category = "database";
                help = "Start postgres instance";
                command = ''
                  [ ! -d $PGDATA ] && pg:setup
                  pg_ctl -D $PGDATA -U postgres start -l log/postgres.log
                '';
              }
              {
                name = "pg:stop";
                category = "database";
                help = "Stop postgres instance";
                command = ''
                  pg_ctl -D $PGDATA -U postgres stop
                '';
              }
              {
                name = "pg:console";
                category = "database";
                help = "Open database console";
                command = ''
                  psql --host $PGDATA -U postgres
                '';
              }
              {
                name = "run_file";
                category = "database";
                help = "Run a file in the database";
                command = ''
                  psql --host $PGDATA -U postgres -f $1
                '';
              }
            ];
          };
        };
      }
    );
}
