{ fetchFromGitHub }:
let
  pname = "tpm";
  version = "3.1.0";
in
fetchFromGitHub {
  owner = "tmux-plugins";
  repo = "tpm";
  rev = "refs/tags/v${version}";
  hash = "sha256-CeI9Wq6tHqV68woE11lIY4cLoNY8XWyXyMHTDmFKJKI=";
}
