import Control.Monad
import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util



hostsFile = "hosts"
ansible = "ansible-playbook -i " ++ hostsFile


main :: IO ()
main = shakeArgs shakeOptions $ do
  "ping" ~> cmd "ansible all -i" hostsFile "-m ping"

  "common" ~> do
    cmd ansible "--ask-become-pass common.yml"

  "ytoyama" ~> do
    cmd ansible "ytoyama.yml"

  "clean" ~> do
    cmd Shell "rm -f *.retry"
