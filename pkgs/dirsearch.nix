{ buildPythonPackage
, fetchFromGitHub
, pysocks
, jinja2
, certifi
, defusedxml
, markupsafe
, pyopenssl
, charset-normalizer
, requests
, requests_ntlm
, colorama
, pyparsing
, beautifulsoup4
, mysql-connector
, psycopg
, requests-toolbelt
, setuptools
, pythonRelaxDepsHook
}:
buildPythonPackage rec {
  pname = "dirsearch";
  version = "0.4.3";
  pyproject = true;
  doCheck = true;

  src = fetchFromGitHub {
    owner = "maurosoria";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-eXB103qUB3m7V/9hlq2xv3Y3bIz89/pGJsbPZQ+AZXs=";
  };

  nativeBuildInputs = [
    setuptools
    pythonRelaxDepsHook
  ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    pysocks
    jinja2
    certifi
    defusedxml
    markupsafe
    pyopenssl
    charset-normalizer
    requests
    requests_ntlm
    colorama
    pyparsing
    beautifulsoup4
    mysql-connector
    psycopg
    requests-toolbelt
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "ntlm_auth>=1.5.0" ""
  '';
}
