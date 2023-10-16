{ buildGoModule, fetchFromGitHub }: 

buildGoModule rec {
  pname = "gobuster";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "OJ";
    repo = "gobuster";
    rev = "refs/tags/v${version}";
    hash = "sha256-LZL9Zje2u0v6iAQinfjflvusV57ys5J5Il6Q7br3Suc=";
  };

  vendorHash = "sha256-w+G5PsWXhKipjYIHtz633sia+Wg9FSFVpcugEl8fp0E=";
}
