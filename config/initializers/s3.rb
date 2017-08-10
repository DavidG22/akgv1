S3_CONFIG = YAML.load_file("#{::Rails.root}/config/s3.yml")
S3_CREDENTIALS = S3_CONFIG[::Rails.env]
