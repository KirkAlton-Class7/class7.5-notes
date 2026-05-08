# Week 7 Lab

## Goal

Deploy a proof-of-concept (POC) static website that is entirely automated with GCS (a GCP bucket) with some sample static assets I provide and an image of your choosing.

## Basic Setup

1. Navigate to where you want to do this project.
2. Make a folder for it if needed. This folder **cannot** be inside an existing local Git repo.
3. Open VS Code.
4. Open the terminal in VS Code.
5. Use `pwd` to make sure you are in the right folder.
6. Run this command to download the needed assets: `curl https://raw.githubusercontent.com/aaron-dm-mcdonald/class7-5-notes/refs/heads/main/week-7/bam/download-assets.sh | sh`
7. Make your `provider.tf`, `backend.tf`, and such as we have done in class.
8. Make a basic bucket in a `main.tf` file (or whatever you call it).
9. Make sure it works.
10. Get the static assets in the bucket with Terraform, one at a time, testing each time.
11. Make the bucket publicly accessible and make sure a friend in class can access the objects from their computer.
12. Adjust the settings on the bucket for static website hosting.
13. Work on the output for the index page's URL.

---

## Guidance

### Hints

- **Official docs:** Just read the first 3-4 sentences here -- it makes it sound hard but that is for setting up extra things we are not doing:
  https://docs.cloud.google.com/storage/docs/hosting-static-website

- **For people who have done this in AWS:** It works quite differently here and you do not get a special static site endpoint.

- **You will need to upload 4 objects to your bucket:**
  - 2 HTML documents: the `index.html` page and the `error.html` page
  - The CSS file to make the HTML look a little pretty
  - An image of your choice

  This means 4 object resources. The code does not need to be "concise" -- copy and paste is fine as long as it works! It is more important that you write the code than that it uses every fancy Terraform feature that nobody expects you to know.

- **Assets provided:** The 3 assets (the HTML files and the CSS file) are provided, so you only need to supply an image of your choice.

- **Want to make the pages fancier?** Go ahead -- but realize this is a static site, so only client-side code is supported. This is totally optional and you should not attempt it until your proof of concept is working.

- **Force destroy:** On the bucket resource, make sure you set `force_destroy = true` to avoid headaches.

- **Naming:** The image filename must match what is referenced in the HTML document. Ask your group leader if you are unsure, but it will be fairly obvious when you look at the HTML.

- **Making the bucket public:** You will need to give the bucket the IAM role `roles/storage.objectViewer` with the member set to `allUsers` (we want everyone to be able to view the objects).
  Use the IAM member resource -- all 3 should work, but the IAM member is what is "correct" or "safe" in most cases.
  - [Google Bucket IAM Doc](https://docs.cloud.google.com/storage/docs/access-control/iam)
  - [Terraform registry IAM resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam#google_storage_bucket_iam_member-1)

---

## Follow-Up Questions

When you are done, ideally you can answer the following:

1. Is Terraform a good tool to provision buckets?
2. Is Terraform an ideal tool to upload objects into buckets? Why or why not?
3. Explain how you wrote the output (if you did). The output can be challenging.
4. IAM and access:
   - Did you need uniform bucket-level access? Do you know what it does?
   - Explain the IAM resource. Why is it needed? Was it hard to implement? Did the hints help?
5. What setting did you change to enable static website hosting on the bucket?
6. What changes could improve this infrastructure?