class DirtyHashy < Hash
  MAJOR = 0
  MINOR = 2
  TINY  = 1

  VERSION = [MAJOR, MINOR, TINY].join(".")
end