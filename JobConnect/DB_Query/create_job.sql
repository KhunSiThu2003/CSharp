CREATE TABLE [dbo].[Jobs] (
    [JobId]           NVARCHAR (50)  NOT NULL,
    [Employer_Id]       NVARCHAR (50)  NOT NULL,
    [Title]           NVARCHAR (100) NOT NULL,
    [Description]     NVARCHAR (MAX) NOT NULL,
    [Requirements]    NVARCHAR (MAX) NULL,
    [SalaryRange]     NVARCHAR (50)  NULL,
    [JobType]         NVARCHAR (20)  NOT NULL,
    [ExperienceLevel] NVARCHAR (20)  NULL,
    [Location]        NVARCHAR (100) NULL,
    [IsRemote]        BIT            DEFAULT ((0)) NULL,
    [PostedDate]      DATETIME       DEFAULT (getdate()) NULL,
    [ExpiryDate]      DATETIME       NULL,
    [IsActive]        BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([JobId] ASC),
    FOREIGN KEY ([Employer_Id]) REFERENCES [dbo].[Employer] ([Employer_Id])
);

