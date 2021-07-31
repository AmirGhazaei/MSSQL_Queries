USE DATABASE_NAME;
GO

DECLARE @BCFileName VARCHAR (1000);
DECLARE @BCFileNameOld VARCHAR (1000);

SELECT @BCFileName =
    (
        SELECT N'C:\Backups\DATABASE_NAME-' + CONVERT ( VARCHAR (500), GETDATE (), 112 ) + '.bak'
    );

BACKUP DATABASE [DATABASE_NAME]
    TO  DISK = @BCFileName
    WITH CHECKSUM;

SELECT @BCFileNameOld = 'del ' +
    (
        SELECT N'C:\Backups\DATABASE_NAME-' + CONVERT ( VARCHAR (500), DATEADD ( DAY, -2, GETDATE ()), 112 ) + '.bak'
    );
-- Delet 2 days ago backup file
EXEC master.dbo.xp_cmdshell @BCFileNameOld;
