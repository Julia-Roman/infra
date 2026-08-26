{
  mkService,
  pkgs,
  ...
}:
{
  systemd.services.umami =
    mkService
      ''
        PRISMA_SCHEMA_ENGINE_BINARY="${pkgs.prisma-engines}/bin/schema-engine"
        PRISMA_QUERY_ENGINE_BINARY="${pkgs.prisma-engines}/bin/query-engine"
        PRISMA_QUERY_ENGINE_LIBRARY="${pkgs.prisma-engines}/lib/libquery_engine.node"
        PRISMA_FMT_BINARY="${pkgs.prisma-engines}/bin/prisma-fmt"
        PATH="$PWD/node_modules/.bin/:$PATH"
        NODE_ENV=production
        PORT=1700
        node node_modules/next/dist/bin/next start
      ''
      "/home/supa/git/umami"
      (
        with pkgs;
        [
          nodejs_22
          pnpm
          yarn
          vips
          python3
          prisma-engines
          openssl
        ]
      );
}
