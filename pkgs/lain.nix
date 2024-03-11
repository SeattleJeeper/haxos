{ lua, fetchFromGitHub }:
lua.pkgs.buildLuarocksPackage {
  pname = "lain";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "lcpz";
    repo = "lain";
    rev = "88f5a8abd2649b348ffec433a24a263b37f122c0";
    hash = "sha256-MH/aiYfcO3lrcuNbnIu4QHqPq25LwzTprOhEJUJBJ7I=";
  };
  
  propagatedBuildInputs = [
    lua.pkgs.dkjson
  ];
}
