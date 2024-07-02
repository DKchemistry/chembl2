import os
import pandas as pd
import logging
from datetime import datetime

# Constants
DATASETS = [
    "dudez_0pt5",
    "dudez_1pt0",
    "extrema_0pt5",
    "extrema_1pt0",
    "goldilocks_0pt5",
    "goldilocks_1pt0",
]
METRICS = ["strain_enrichment_metrics", "strain_log_aucs", "strain_roc_metrics"]
PROTEINS = [
    "AA2AR",
    "ABL1",
    "ACES",
    "ADA",
    "ADRB2",
    #"AMPC",
    "ANDR",
    "CSF1R",
    "CXCR4",
    "DEF",
    #"DRD4",
    "EGFR",
    "FA10",
    "FA7",
    "FABP4",
    "FGFR1",
    "FKB1A",
    "GLCM",
    "HDAC8",
    "HIVPR",
    "HMDH",
    "HS90A",
    "ITAL",
    "KIT",
    "KITH",
    "LCK",
    "MAPK2",
    "MK01",
    "MT1",
    "NRAM",
    "PARP1",
    "PLK1",
    "PPARA",
    "PTN1",
    "PUR2",
    "RENI",
    "ROCK1",
    "SRC",
    "THRB",
    "TRY1",
    "TRYB1",
    "UROK",
    "XIAP",
]
INPUT_DIR = "./papermill/torsion_csv"
OUTPUT_DIR = "./merged_data"

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)


# Set up logging
log_dir = "./logs"
os.makedirs(log_dir, exist_ok=True)
log_file = os.path.join(
    log_dir, f"merge_datasets_log_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt"
)
logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)


def get_files_for_dataset(dataset):
    """Get all relevant non-pareto files for a given dataset."""
    files = [
        f
        for f in os.listdir(INPUT_DIR)
        if f.endswith(f"{dataset}.csv") and not "pareto" in f
    ]
    logging.info(f"Files found for dataset {dataset}: {files}")
    return files


def merge_dataset(dataset):
    """Merge all non-pareto files for a given dataset, processing each protein separately."""
    files = get_files_for_dataset(dataset)
    if not files:
        raise ValueError(f"No non-pareto files found for dataset: {dataset}")

    logging.info(f"Processing files for dataset {dataset}")

    protein_data = {}
    for file in files:
        logging.info(f"Processing {file}")
        df = pd.read_csv(os.path.join(INPUT_DIR, file))

        if df.empty:
            logging.warning(f"Empty file encountered: {file}")
            continue

        protein = df["Protein"].iloc[0].split("_")[0]
        if protein not in protein_data:
            protein_data[protein] = []

        protein_data[protein].append(df)

    merged_data = []
    for protein, dataframes in protein_data.items():
        if (
            len(dataframes) < 3
        ):  # Expecting 3 files per protein (enrichment, log AUCs, ROC metrics)
            logging.warning(
                f"Incomplete data for protein {protein} in dataset {dataset}. Found {len(dataframes)} file(s) instead of 3."
            )
            continue  # Skip this protein if we don't have all the required data

        protein_merged = dataframes[0]
        for df in dataframes[1:]:
            protein_merged = protein_merged.merge(
                df, on=["Protein", "Strain Energy Cutoff"], how="outer"
            )
        merged_data.append(protein_merged)

    if not merged_data:
        raise ValueError(f"No valid data found for dataset: {dataset}")

    final_data = pd.concat(merged_data, ignore_index=True)
    final_data["Protein"] = final_data["Protein"].apply(lambda x: x.split("_")[0])

    logging.info(f"Final columns: {final_data.columns.tolist()}")
    logging.info(f"Final shape: {final_data.shape}")
    logging.info(f"Proteins included: {final_data['Protein'].unique().tolist()}")

    return final_data


def main():
    for dataset in DATASETS:
        logging.info(f"Processing dataset: {dataset}")
        try:
            merged_data = merge_dataset(dataset)
            output_file = os.path.join(
                OUTPUT_DIR, f"combined_torsion_data_{dataset}.csv"
            )
            merged_data.to_csv(output_file, index=False)
            logging.info(f"Merged data saved to: {output_file}")
            logging.info(f"Shape of merged data: {merged_data.shape}")
        except ValueError as e:
            logging.error(f"Error processing dataset {dataset}: {str(e)}")
        except Exception as e:
            logging.error(f"Unexpected error processing dataset {dataset}: {str(e)}")
        finally:
            logging.info("\n")

    logging.info("Processing complete.")


if __name__ == "__main__":
    main()
    print(f"Processing complete. Log file saved to: {log_file}")
