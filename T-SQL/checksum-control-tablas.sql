SELECT CHECKSUM_AGG(CHECKSUM(*))
FROM STG.[dbo].[STG_OB_OnBoardings]
WHERE created between '2020-10-01' and '2020-10-31'

--SELECT CHECKSUM_AGG(CHECKSUM(id)) ,CHECKSUM_AGG(CHECKSUM(created)),CHECKSUM_AGG(CHECKSUM(updated)),CHECKSUM_AGG(CHECKSUM(application)),CHECKSUM_AGG(CHECKSUM(dni)),CHECKSUM_AGG(CHECKSUM(first_name)),CHECKSUM_AGG(CHECKSUM(last_name)),CHECKSUM_AGG(CHECKSUM(process_id)),CHECKSUM_AGG(CHECKSUM(status)),CHECKSUM_AGG(CHECKSUM(step)),CHECKSUM_AGG(CHECKSUM(source)),CHECKSUM_AGG(CHECKSUM(user_token))

SELECT CHECKSUM_AGG(CHECKSUM(*))
FROM OPENQUERY([ONBOARDING], 'SELECT id,created,updated,application,dni,first_name,last_name,process_id,status,step,source,user_token from onboarding.onboardings
							  where created between ''2020-10-01'' and ''2020-10-31'';')