    SELECT CAST(DB_NAME ( database_id ) AS VARCHAR (40))                                                        database_name
         , DATEDIFF ( SECOND, last_commit_time, GETDATE ())                                                     AS data_loss_second
         , DATEDIFF ( MINUTE, last_commit_time, GETDATE ())                                                     AS data_loss_minute
         , CONVERT ( VARCHAR (20), last_commit_time, 22 )                                                       last_commit_time
         , CAST(CAST(((DATEDIFF ( s, last_commit_time, GETDATE ())) / 3600) AS VARCHAR) + ' hour(s), '
                + CAST((DATEDIFF ( s, last_commit_time, GETDATE ()) % 3600) / 60 AS VARCHAR) + ' min, '
                + CAST((DATEDIFF ( s, last_commit_time, GETDATE ()) % 60) AS VARCHAR) + ' sec' AS VARCHAR (30)) time_behind_primary
         , redo_queue_size
         , redo_rate
         , CONVERT (
                       VARCHAR (20)
                     , DATEADD ( mi, (redo_queue_size / IIF(redo_rate = 0, 1, redo_rate) / 60.0), GETDATE ())
                     , 22
                   )                                                                                            estimated_completion_time
         , CAST((redo_queue_size / IIF(redo_rate = 0, 1, redo_rate) / 60.0) AS DECIMAL (10, 2))                 [estimated_recovery_time_minutes]
         , (redo_queue_size / IIF(redo_rate = 0, 1, redo_rate))                                                 [estimated_recovery_time_seconds]
         , CONVERT ( VARCHAR (20), GETDATE (), 22 )                                                             [current_time]
    FROM   sys.dm_hadr_database_replica_states
    WHERE
           last_redone_time IS NOT NULL;
