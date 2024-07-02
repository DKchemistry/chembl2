import pandas as pd
import os

# List of proteins that were intentionally skipped
SKIPPED_PROTEINS = ["AMPC", "DRD4"]


def analyze_datasets(directory):
    datasets = [
        f
        for f in os.listdir(directory)
        if f.startswith("combined_torsion_data_") and f.endswith(".csv")
    ]

    all_proteins = set()
    dataset_info = {}
    unexpected_data = {}

    for dataset in datasets:
        df = pd.read_csv(os.path.join(directory, dataset))
        proteins = set(df["Protein"].unique())
        all_proteins.update(proteins)
        dataset_info[dataset] = {
            "total_rows": len(df),
            "unique_proteins": len(proteins),
            "proteins": proteins,
        }

        # Check for unexpected data
        unexpected = proteins.intersection(SKIPPED_PROTEINS)
        if unexpected:
            unexpected_data[dataset] = unexpected

    # Remove skipped proteins from the all_proteins set
    expected_proteins = all_proteins - set(SKIPPED_PROTEINS)

    print("Summary:")
    for dataset, info in dataset_info.items():
        print(f"\n{dataset}:")
        print(f"  Total rows: {info['total_rows']}")
        print(f"  Unique proteins: {info['unique_proteins']}")

    print("\nMissing Proteins (excluding intentionally skipped proteins):")
    for dataset, info in dataset_info.items():
        missing = expected_proteins - info["proteins"]
        if missing:
            print(f"\n{dataset} is missing:")
            for protein in sorted(missing):
                print(f"  {protein}")
        else:
            print(f"\n{dataset} is not missing any expected proteins.")

    print("\nProtein counts per dataset:")
    for protein in sorted(expected_proteins):
        counts = [
            len(
                pd.read_csv(os.path.join(directory, dataset))[
                    pd.read_csv(os.path.join(directory, dataset))["Protein"] == protein
                ]
            )
            for dataset in datasets
        ]
        print(f"{protein}: {counts}")

    print(
        f"\nNote: The following proteins were intentionally skipped: {', '.join(SKIPPED_PROTEINS)}"
    )

    if unexpected_data:
        print("\nWARNING: Unexpected data found for skipped proteins:")
        for dataset, proteins in unexpected_data.items():
            print(f"  {dataset}: {', '.join(proteins)}")
        print("This may indicate that old files were not properly cleared.")


if __name__ == "__main__":
    analyze_datasets("./merged_data")
