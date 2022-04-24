enum ArchiveStatus {
  none,
  paused,
  unlocking,
  waitingForDownloadPageUrl,
  waitingForDownloadUrl,
  downloading,
  downloaded,
  unpacking,
  completed,
}

class GalleryArchive {
  int gpCount;
  int creditCount;

  int originalCost;
  String originalSize;

  int? resampleCost;
  String? resampleSize;

  GalleryArchive({
    required this.gpCount,
    required this.creditCount,
    required this.originalCost,
    required this.originalSize,
    this.resampleCost,
    this.resampleSize,
  });
}