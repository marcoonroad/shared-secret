# OPAM version to install
export OPAM_VERSION=1.2
# OPAM packages needed to build tests
export OPAM_PACKAGES='ocamlfind ounit oasis'

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
echo ""
echo ""
echo "***************************"
echo "*                         *"
echo "*   <Environment> done!   *"
echo "*                         *"
echo "***************************"
echo ""
echo ""

# compile & run tests
# export LIBS='../lib/SharedSecret.ml'
# export OCAMLFIND='/home/travis/.opam/system/bin/ocamlfind'

# mkdir _test
# cd lib_test
# for file in *.ml
# do
#    $OCAMLFIND ocamlc -o "../_test/$file" -package oUnit -linkpkg -I ../lib -g $LIBS $file
# done
# echo "*** <Link> done! ***"

# cd ../_test
# for test in *
# do
#    ./$test
# done
# cd ..

export OASIS='/home/travis/.opam/system/bin/oasis'
$OASIS setup
ocaml setup.ml -configure --enable-tests
ocaml setup.ml -build
ocaml setup.ml -test
echo ""
echo ""
echo "*********************"
echo "*                   *"
echo "*   <Tests> done!   *"
echo "*                   *"
echo "*********************"
echo ""
echo ""

# clean
ocaml setup.ml -distclean
echo ""
echo ""
echo "***********************"
echo "*                     *"
echo "*   <Cleanup> done!   *"
echo "*                     *"
echo "***********************"

# end
