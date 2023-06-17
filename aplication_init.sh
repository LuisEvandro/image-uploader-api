# Terraform configure
terraform init 
terraform destroy -auto-approve
terraform apply -auto-approve
# Prisma configure mongoDB
npx prisma generate
# Start Aplication
npm run dev