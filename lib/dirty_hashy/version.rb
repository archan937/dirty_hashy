class DirtyHashy < Hash
  MAJOR = 0
  MINOR = 1
  TINY  = 3

  VERSION = [MAJOR, MINOR, TINY].join(".")
end