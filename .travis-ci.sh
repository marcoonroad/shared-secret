# OPAM version to install
export OPAM_VERSION=1.2
# OPAM packages needed to build tests
export OPAM_PACKAGES='ocamlfind ounit'

# install ocaml from apt
sudo apt-get update -qq
sudo apt-get install -qq ocaml

# install opam
curl -L https://github.com/OCamlPro/opam/archive/${OPAM_VERSION}.tar.gz | tar xz -C /tmp
pushd /tmp/opam-${OPAM_VERSION}
./configure
make lib-ext
make
sudo make install
opam init -a
opam config setup -a
popd

# install packages from opam
opam install -q -y ${OPAM_PACKAGES}
echo "*** <Install> done! ***"

# compile & run tests
export LIBS='../lib/SharedSecret.ml'
export OCAMLFIND='/home/travis/.opam/system/bin/ocamlfind'

mkdir _test
cd lib_test
for file in *.ml
do
    $OCAMLFIND ocamlc -o "../_test/$file" -package oUnit -linkpkg -I ../lib -g $LIBS $file
done
echo "*** <Link> done! ***"

cd ../_test
for test in *
do
    ./$test
done
cd ..
echo "*** <Test> done! ***"

# clean
rm -R -f _test
echo "*** <Clear> done! ***"
echo "*** <Build> done! ***"