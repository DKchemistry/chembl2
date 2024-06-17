import os

# List of directories
directories = [
    "AA2AR", "ABL1", "ACES", "ADA", "ADRB2", "AMPC", "ANDR", "CSF1R", "CXCR4", "DEF",
    "DRD4", "EGFR", "FA10", "FA7", "FABP4", "FGFR1", "FKB1A", "GLCM", "HDAC8", "HIVPR",
    "HMDH", "HS90A", "ITAL", "KIT", "KITH", "LCK", "MAPK2", "MK01", "MT1", "NRAM",
    "PARP1", "PLK1", "PPARA", "PTN1", "PUR2", "RENI", "ROCK1", "SRC", "THRB", "TRY1",
    "TRYB1", "UROK", "XIAP"
]

# Get the current working directory
base_dir = os.getcwd()

# Iterate over each directory
for directory in directories:
    dir_path = os.path.join(base_dir, directory)
    grid_file = os.path.join(dir_path, f"{directory}-gridgen.zip")
    
    # Find all .sdf files in the directory
    for root, _, files in os.walk(dir_path):
        for file in files:
            if file.endswith(".sdf"):
                sdf_file = os.path.join(root, file)
                sdf_filename = os.path.basename(sdf_file)
                in_filename = f"glide_{os.path.splitext(sdf_filename)[0]}.in"
                in_file = os.path.join(root, in_filename)
                
                with open(in_file, 'w') as f:
                    f.write(f"GRIDFILE {grid_file}\n")
                    f.write(f"LIGANDFILE {sdf_file}\n")
                    f.write("POSE_OUTTYPE ligandlib_sd\n")
                    f.write("DOCKING_METHOD confgen\n")
                    f.write("PRECISION SP\n")
                    f.write("AMIDE_MODE penal\n")
                    f.write("SAMPLE_RINGS True\n")
                    f.write("EPIK_PENALTIES True\n")
                    f.write("WRITE_CSV True\n")
                    f.write("WRITE_RES_INTERACTION True\n")
                
                print(f"Generated {in_file}")

print("All glide.in files have been generated.")
