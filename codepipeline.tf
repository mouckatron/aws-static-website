
resource "aws_codepipeline" "frontend" {
  name     = "${var.appname}-frontend"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        RepositoryName       = "${var.appname}-sitecode"
        BranchName           = "master"
        PollForSourceChanges = false
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = "${var.appname}-frontend"
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["build_output"]
      configuration = {
        BucketName = aws_s3_bucket.frontend.id
        Extract    = true
      }
    }
  }

  tags = {
    appname = var.appname
  }
}

resource "aws_codebuild_project" "frontend" {
  name          = "${var.appname}-frontend"
  description   = "Build frontend for ${var.appname}"
  build_timeout = "5"
  service_role  = aws_iam_role.codepipeline.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
  }

  tags = {
    appname = var.appname
  }
}

resource "aws_cloudwatch_event_rule" "frontend_pipeline" {
  name          = "${var.appname}-frontend-pipeline"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.codecommit"
  ],
  "detail-type": [
    "CodeCommit Repository State Change"
  ],
  "resources": [
    "${aws_codecommit_repository.sitecode.arn}"
  ],
  "detail": {
    "event": [
      "referenceCreated",
      "referenceUpdated"
    ],
    "referenceType": [
      "branch"
    ],
    "referenceName": [
      "master"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "frontend_pipeline" {
  rule     = aws_cloudwatch_event_rule.frontend_pipeline.name
  arn      = aws_codepipeline.frontend.arn
  role_arn = aws_iam_role.codepipeline.arn
}
