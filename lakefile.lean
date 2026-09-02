import Lake
open Lake DSL

package "template" where
  version := v!"0.1.0"

lean_lib «Template»

@[default_target]
lean_exe "template" where
  root := `Main
