
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name SAOestCPU -dir "D:/jjj/SAOestCPU/planAhead_run_5" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/jjj/SAOestCPU/THINPAD_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/jjj/SAOestCPU} {ipcore_dir} }
add_files [list {ipcore_dir/font.ncf}] -fileset [get_property constrset [current_run]]
set_param project.pinAheadLayout  yes
set_property target_constrs_file "THINPAD_top.ucf" [current_fileset -constrset]
add_files [list {THINPAD_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
