## Diagnosis of Mild Cognitive Impairment (MCI) Using Graph Neural Networks Based on Functional Near-Infrared Spectroscopy (fNIRS) Data

This repository provides code and resources for diagnosing Mild Cognitive Impairment (MCI) using Temporal Graph Neural Networks (TGNNs) on fNIRS data. The project workflow includes data preprocessing, temporal graph generation, model training, and evaluation.

## Overview

This project leverages functional near-infrared spectroscopy (fNIRS) data to train a graph neural network model that detects MCI. Through a pipeline of preprocessing, graph construction, and model training, the project uses features from the fNIRS data to train a GConvGRU-based Temporal Graph Neural Network model.

## Contents

- **Dataset**: Available upon request.
- **Preprocessing Files**: Located in `Matlab` and `Python` folders, named with "preprocessing" prefixes (e.g., `preprocessing1_...`).
- **Graph Generation**: Instructions for creating temporal graphs from preprocessed data.
- **Model Training**: Notebooks for model training and evaluation.

## Preprocessing Workflow

The preprocessing pipeline for raw fNIRS data includes the following steps:
1. **Removing spikes** from the raw data.
2. **Replacing NaN values** with a 5-second moving average.
3. **Detrending** the signal to remove low-frequency drifts.
4. **TDDR (Task-based Decomposition and Denoising Routine)** for noise reduction.
5. **Bandpass filtering** to retain relevant signal frequencies.
6. **Detrending** the filtered signal to remove residual trends.
7. **Normalization** of the data for consistency across samples.
8. **Generating temporal graphs** with nodes as fNIRS channels and edges representing functional connectivity.
9. **Feature selection** using the Mann-Whitney test and XGBoost to identify key signal and functional features.
10. **Classification** using Temporal Graph Neural Networks, such as GConvGRU.

## Getting Started

### 1. Download the Dataset

The dataset can be downloaded upon request.

### 2. Using Processed Data

If you already have preprocessed data, proceed with the steps below. Otherwise, follow the preprocessing instructions to prepare your dataset.

### 3. Generate Temporal Graphs

To construct temporal graphs from the preprocessed data, run the notebook:

`making_temporal_graphs.ipynb`

This notebook prepares the data for training by generating temporal graphs where nodes represent fNIRS channels, and edges capture functional connectivity features.

### 4. Train the Model and Evaluate Results

To train the GConvGRU model and view results, execute:

`model_gconvgru.ipynb`

### 5. Preprocessing Code

Preprocessing scripts for data preparation can be found in the `Matlab` and `Python` folders, with file names beginning with "preprocessing" (e.g., `preprocessing1_...`).
