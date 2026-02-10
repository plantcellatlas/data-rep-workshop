#!/usr/bin/env Rscript
library(Seurat)
args <- commandArgs(trailingOnly=TRUE)
input_rds=args[1]
output_rds=args[2]
obj=readRDS(input_rds)
obj[["RNA"]] <- split(obj[["RNA"]], f = obj$sample)
obj <- NormalizeData(obj)
obj <- FindVariableFeatures(obj)
obj <- ScaleData(obj)
obj <- RunPCA(obj)
obj <- FindNeighbors(obj, dims = 1:30, reduction = "pca")
obj <- FindClusters(obj, resolution = 2, cluster.name = "unintegrated_clusters")
obj <- RunUMAP(obj, dims = 1:30, reduction = "pca", reduction.name = "umap.unintegrated")
obj <- IntegrateLayers(
  object = obj, method = CCAIntegration,
  orig.reduction = "pca", new.reduction = "integrated.cca",
  verbose = FALSE
)
obj <- FindNeighbors(obj, reduction = "integrated.cca", dims = 1:30)
obj <- FindClusters(obj, resolution = 2, cluster.name = "cca_clusters")
obj <- RunUMAP(obj, dims = 1:30, reduction = "integrated.cca", reduction.name = "umap.integrated")
obj=JoinLayers(obj)
saveRDS(obj, output_rds)
