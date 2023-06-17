enum ImageUploadedStatus {
  CREATED,
  UPLOADED,
  FAILED,
  DELETED,
}

export interface ImageUploaded {
  id?: String;
  name: String;
  description?: String;
  status: ImageUploadedStatus;
  create_at: Date;
  update_at?: Date;
}
