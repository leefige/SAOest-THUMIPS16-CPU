
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name SAOestCPU -dir "C:/Users/Liyf/Desktop/CO/proj/THINPAD/SAOestCPU/planAhead_run_5" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Liyf/Desktop/CO/proj/THINPAD/SAOestCPU/THINPAD_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Liyf/Desktop/CO/proj/THINPAD/SAOestCPU} {ipcore_dir} }
add_files [list {ipcore_dir/DualRAM.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "THINPAD_top.ucf" [current_fileset -constrset]
add_files [list {THINPAD_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
