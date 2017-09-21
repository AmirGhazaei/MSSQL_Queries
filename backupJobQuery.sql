USE DATABASE_NAME
GO

DECLARE @BCFileName varchar(1000)
DECLARE @BCFileNameOld varchar(1000)

SELECT @BCFileName = (SELECT N'C:\Backups\DATABASE_NAME-' + convert(varchar(500),GetDate(),112) + '.bak') 

BACKUP DATABASE [DATABASE_NAME]
TO  DISK =  @BCFileName 
WITH CHECKSUM;

SELECT @BCFileNameOld = 'del ' + (SELECT N'C:\Backups\DATABASE_NAME-' + convert(varchar(500),DATEADD(DAY,-2,GetDate()),112) + '.bak');
 -- Delet 2 days ago backup file
exec master.dbo.xp_cmdshell @BCFileNameOld
