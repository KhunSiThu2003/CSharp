CREATE TABLE [dbo].[JobSeeker] (
    [JobSeeker_Id]                   NVARCHAR (50)  NOT NULL,
    [Name]                 NVARCHAR (50)  NOT NULL,
    [Email]                    NVARCHAR (100) NOT NULL,
    [Password]                 NVARCHAR (MAX) NOT NULL,
    [CreatedDate]              DATETIME       DEFAULT (getdate()) NOT NULL,
    [IsActive]                 BIT            DEFAULT ((0)) NOT NULL,
    [IsEmailVerified]          BIT            DEFAULT ((0)) NOT NULL,
    [VerificationCode]         NVARCHAR (6)   NULL,
    [VerificationCodeExpiry]   DATETIME       NULL,
    [VerificationAttempts]     INT            DEFAULT ((0)) NOT NULL,
    [LastVerificationAttempt]  DATETIME       NULL,
    [PasswordResetOTP]         NVARCHAR (6)   NULL,
    [PasswordResetOTPExpiry]   DATETIME       NULL,
    [PasswordResetAttempts]    INT            DEFAULT ((0)) NOT NULL,
    [LastPasswordResetAttempt] DATETIME       NULL,
    [ProfilePicture]           NVARCHAR (255) NULL,
    [Phone]                    NVARCHAR (20)  NULL,
    [Bio]                      NVARCHAR (500) NULL,
    [Title]                    NVARCHAR (100) NULL,
    [Address]                  NVARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([JobSeeker_Id] ASC)
);

