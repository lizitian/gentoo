# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{5,6} pypy )

MY_PN="Whoosh"

inherit distutils-r1

DESCRIPTION="Fast, pure-Python full text indexing, search and spell checking library"
HOMEPAGE="https://bitbucket.org/mchaput/whoosh/wiki/Home/ https://pypi.org/project/Whoosh/"
SRC_URI="mirror://pypi/W/${MY_PN}/${MY_PN}-${PV}.zip"

DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	# (backport from upstream)
	sed -i -e '/cmdclass/s:pytest:PyTest:' setup.py || die

	# Prevent un-needed download during build
	sed -e "/^              'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# https://bitbucket.org/mchaput/whoosh/issue/403/
	use doc && sphinx-build -b html -c docs/source/ docs/source/ docs/source/build/html
}

python_test() {
	esetup.py test
}

python_install_all() {
	local DOCS=( README.txt )
	use doc && local HTML_DOCS=( docs/source/build/html/. )
	distutils-r1_python_install_all
}
