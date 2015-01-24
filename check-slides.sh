
set -o errexit

mkdir -p slides-code

markdown-unlit -h slides.md slides.md slides-code/Slides.hs
echo 'main :: IO ()\nmain = return ()' >> slides-code/Slides.hs

cabal exec ghc -- -islides-code -outputdir /tmp/slides slides-code/Slides.hs -O0 -c -Wall -Werror -fno-warn-unused-binds
