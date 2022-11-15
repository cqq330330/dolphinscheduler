create table SYSDBA.QRTZ_JOB_DETAILS
(
    SCHED_NAME        varchar(120) not null,
    JOB_NAME          varchar(200) not null,
    JOB_GROUP         varchar(200) not null,
    DESCRIPTION       varchar(250),
    JOB_CLASS_NAME    varchar(250) not null,
    IS_DURABLE        varchar(1)   not null,
    IS_NONCONCURRENT  varchar(1)   not null,
    IS_UPDATE_DATA    varchar(1)   not null,
    REQUESTS_RECOVERY varchar(1)   not null,
    JOB_DATA          blob
);
alter table SYSDBA.QRTZ_JOB_DETAILS
    add constraint PK primary key (SCHED_NAME, JOB_NAME, JOB_GROUP);
create index "IDX_QRTZ_J_GRP" on SYSDBA.QRTZ_JOB_DETAILS ("SCHED_NAME", "JOB_GROUP") indextype is btree global;
create index "IDX_QRTZ_J_REQ_RECOVERY" on SYSDBA.QRTZ_JOB_DETAILS ("SCHED_NAME", "REQUESTS_RECOVERY") indextype is btree global;

CREATE table SYSDBA.QRTZ_TRIGGERS
(
    SCHED_NAME     varchar(120) not null,
    TRIGGER_NAME   varchar(200) not null,
    TRIGGER_GROUP  varchar(200) not null,
    JOB_NAME       varchar(200) not null,
    JOB_GROUP      varchar(200) not null,
    DESCRIPTION    varchar(250),
    NEXT_FIRE_TIME bigint,
    PREV_FIRE_TIME bigint,
    PRIORITY       integer,
    TRIGGER_STATE  varchar(16)  not null,
    TRIGGER_TYPE   varchar(8)   not null,
    START_TIME     bigint       not null,
    END_TIME       bigint,
    CALENDAR_NAME  varchar(200),
    MISFIRE_INSTR  smallint,
    JOB_DATA       blob
);
alter table SYSDBA.QRTZ_TRIGGERS
    add constraint PK primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);
alter table SYSDBA.QRTZ_TRIGGERS
    add constraint QRTZ_TRIGGERS_IBFK_1 foreign key (SCHED_NAME, JOB_NAME, JOB_GROUP) references SYSDBA.QRTZ_JOB_DETAILS (SCHED_NAME, JOB_NAME, JOB_GROUP) on update restrict on delete restrict;
create index "IDX_QRTZ_T_C" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "CALENDAR_NAME") indextype is btree global;
create index "IDX_QRTZ_T_G" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "TRIGGER_GROUP") indextype is btree global;
create index "IDX_QRTZ_T_J" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "JOB_NAME", "JOB_GROUP") indextype is btree global;
create index "IDX_QRTZ_T_JG" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "JOB_GROUP") indextype is btree global;
create index "IDX_QRTZ_T_NEXT_FIRE_TIME" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "NEXT_FIRE_TIME") indextype is btree global;
create index "IDX_QRTZ_T_NFT_MISFIRE" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "MISFIRE_INSTR", "NEXT_FIRE_TIME") indextype is btree global;
create index "IDX_QRTZ_T_NFT_ST" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "TRIGGER_STATE", "NEXT_FIRE_TIME") indextype is btree global;
create index "IDX_QRTZ_T_NFT_ST_MISFIRE" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "MISFIRE_INSTR", "NEXT_FIRE_TIME", "TRIGGER_STATE") indextype is btree global;
create index "IDX_QRTZ_T_NFT_ST_MISFIRE_GRP" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "MISFIRE_INSTR", "NEXT_FIRE_TIME",
                                                                      "TRIGGER_GROUP",
                                                                      "TRIGGER_STATE") indextype is btree global;
create index "IDX_QRTZ_T_N_G_STATE" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "TRIGGER_GROUP", "TRIGGER_STATE") indextype is btree global;
create index "IDX_QRTZ_T_N_STATE" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP", "TRIGGER_STATE") indextype is btree global;
create index "IDX_QRTZ_T_STATE" on SYSDBA.QRTZ_TRIGGERS ("SCHED_NAME", "TRIGGER_STATE") indextype is btree global;


create table SYSDBA.QRTZ_BLOB_TRIGGERS
(
    SCHED_NAME    varchar(120) not null,
    TRIGGER_NAME  varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    BLOB_DATA     blob
);
alter table SYSDBA.QRTZ_BLOB_TRIGGERS
    add constraint PK primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);
alter table SYSDBA.QRTZ_BLOB_TRIGGERS
    add constraint QRTZ_BLOB_TRIGGERS_IBFK_1 foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references SYSDBA.QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) on update restrict on delete restrict;

create table SYSDBA.QRTZ_CALENDARS
(
    SCHED_NAME    varchar(120) not null,
    CALENDAR_NAME varchar(200) not null,
    CALENDAR      blob         not null
);
alter table SYSDBA.QRTZ_CALENDARS
    add constraint PK primary key (SCHED_NAME, CALENDAR_NAME);

create table SYSDBA.QRTZ_CRON_TRIGGERS
(
    SCHED_NAME      varchar(120) not null,
    TRIGGER_NAME    varchar(200) not null,
    TRIGGER_GROUP   varchar(200) not null,
    CRON_EXPRESSION varchar(120) not null,
    TIME_ZONE_ID    varchar(80)
);
alter table SYSDBA.QRTZ_CRON_TRIGGERS
    add constraint PK primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);
alter table SYSDBA.QRTZ_CRON_TRIGGERS
    add constraint QRTZ_CRON_TRIGGERS_IBFK_1 foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references SYSDBA.QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) on update restrict on delete restrict;

create table SYSDBA.QRTZ_FIRED_TRIGGERS
(
    SCHED_NAME        varchar(120) not null,
    ENTRY_ID          varchar(200) not null,
    TRIGGER_NAME      varchar(200) not null,
    TRIGGER_GROUP     varchar(200) not null,
    INSTANCE_NAME     varchar(200) not null,
    FIRED_TIME        bigint       not null,
    SCHED_TIME        bigint       not null,
    PRIORITY          integer      not null,
    STATE             varchar(16)  not null,
    JOB_NAME          varchar(200),
    JOB_GROUP         varchar(200),
    IS_NONCONCURRENT  varchar(1),
    REQUESTS_RECOVERY varchar(1)
);
alter table SYSDBA.QRTZ_FIRED_TRIGGERS
    add constraint PK primary key (SCHED_NAME, ENTRY_ID);
create index "IDX_QRTZ_FT_INST_JOB_REQ_RCVRY" on SYSDBA.QRTZ_FIRED_TRIGGERS ("SCHED_NAME", "INSTANCE_NAME", "REQUESTS_RECOVERY") indextype is btree global;
create index "IDX_QRTZ_FT_JG" on SYSDBA.QRTZ_FIRED_TRIGGERS ("SCHED_NAME", "JOB_GROUP") indextype is btree global;
create index "IDX_QRTZ_FT_J_G" on SYSDBA.QRTZ_FIRED_TRIGGERS ("SCHED_NAME", "JOB_NAME", "JOB_GROUP") indextype is btree global;
create index "IDX_QRTZ_FT_TG" on SYSDBA.QRTZ_FIRED_TRIGGERS ("SCHED_NAME", "TRIGGER_GROUP") indextype is btree global;
create index "IDX_QRTZ_FT_TRIG_INST_NAME" on SYSDBA.QRTZ_FIRED_TRIGGERS ("SCHED_NAME", "INSTANCE_NAME") indextype is btree global;
create index "IDX_QRTZ_FT_T_G" on SYSDBA.QRTZ_FIRED_TRIGGERS ("SCHED_NAME", "TRIGGER_NAME", "TRIGGER_GROUP") indextype is btree global;


create table SYSDBA.QRTZ_LOCKS
(
    SCHED_NAME varchar(120) not null,
    LOCK_NAME  varchar(40)  not null
);
alter table SYSDBA.QRTZ_LOCKS
    add constraint PK primary key (SCHED_NAME, LOCK_NAME);

create table SYSDBA.QRTZ_PAUSED_TRIGGER_GRPS
(
    SCHED_NAME    varchar(120) not null,
    TRIGGER_GROUP varchar(200) not null
);
alter table SYSDBA.QRTZ_PAUSED_TRIGGER_GRPS
    add constraint PK primary key (SCHED_NAME, TRIGGER_GROUP);

create table SYSDBA.QRTZ_SCHEDULER_STATE
(
    SCHED_NAME        varchar(120) not null,
    INSTANCE_NAME     varchar(200) not null,
    LAST_CHECKIN_TIME bigint       not null,
    CHECKIN_INTERVAL  bigint       not null
);
alter table SYSDBA.QRTZ_SCHEDULER_STATE
    add constraint PK primary key (SCHED_NAME, INSTANCE_NAME);

create table SYSDBA.QRTZ_SIMPLE_TRIGGERS
(
    SCHED_NAME      varchar(120) not null,
    TRIGGER_NAME    varchar(200) not null,
    TRIGGER_GROUP   varchar(200) not null,
    REPEAT_COUNT    bigint       not null,
    REPEAT_INTERVAL bigint       not null,
    TIMES_TRIGGERED bigint       not null
);
alter table SYSDBA.QRTZ_SIMPLE_TRIGGERS
    add constraint PK primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);
alter table SYSDBA.QRTZ_SIMPLE_TRIGGERS
    add constraint QRTZ_SIMPLE_TRIGGERS_IBFK_1 foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references SYSDBA.QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) on update restrict on delete restrict;

create table SYSDBA.QRTZ_SIMPROP_TRIGGERS
(
    SCHED_NAME    varchar(120) not null,
    TRIGGER_NAME  varchar(200) not null,
    TRIGGER_GROUP varchar(200) not null,
    STR_PROP_1    varchar(512),
    STR_PROP_2    varchar(512),
    STR_PROP_3    varchar(512),
    INT_PROP_1    integer,
    INT_PROP_2    integer,
    LONG_PROP_1   bigint,
    LONG_PROP_2   bigint,
    DEC_PROP_1    numeric(13, 4),
    DEC_PROP_2    numeric(13, 4),
    BOOL_PROP_1   varchar(1),
    BOOL_PROP_2   varchar(1)
);
alter table SYSDBA.QRTZ_SIMPROP_TRIGGERS
    add constraint PK primary key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP);
alter table SYSDBA.QRTZ_SIMPROP_TRIGGERS
    add constraint QRTZ_SIMPROP_TRIGGERS_IBFK_1 foreign key (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) references SYSDBA.QRTZ_TRIGGERS (SCHED_NAME, TRIGGER_NAME, TRIGGER_GROUP) on update restrict on delete restrict;


create table SYSDBA.T_DS_ACCESS_TOKEN
(
    "id"          integer identity(1,1) not null comment 'key',
    "user_id"     integer comment 'user id',
    "token"       varchar(64) comment 'token',
    "expire_time" datetime comment 'end time of token',
    "create_time" datetime comment 'create time',
    "update_time" datetime comment 'update time',
    constraint pk primary key (ID)
);

create table SYSDBA.T_DS_ALERT
(
    "id"                      integer identity(1,1) not null comment 'key',
    "title"                   varchar(64) comment 'title',
    "sign"                    varchar(40) not null default '' comment 'sign=sha1(content)',
    "content"                 clob comment 'Message content (can be email, can be SMS. Mail is stored in JSON map, and SMS is string)',
    "alert_status"            tinyint              default 0 comment '0:wait running,1:success,2:failed',
    "warning_type"            tinyint              default 2 comment '1 process is successfully, 2 process/task is failed',
    "log"                     clob comment 'log',
    "alertgroup_id"           integer comment 'alert group id',
    "create_time"             datetime comment 'create time',
    "update_time"             datetime comment 'update time',
    "project_code"            bigint comment 'project_code',
    "process_definition_code" bigint comment 'process_definition_code',
    "process_instance_id"     integer comment 'process_instance_id',
    "alert_type"              integer comment 'alert_type',
    constraint PK primary key (ID)
);

create index "IDX_SIGN" on SYSDBA.T_DS_ALERT ("SIGN") indextype is btree global;
create index "IDX_STATUS" on SYSDBA.T_DS_ALERT ("ALERT_STATUS") indextype is btree global;

create table SYSDBA.T_DS_ALERTGROUP
(
    "id"                 integer identity(2,1) not null comment 'key',
    "alert_instance_ids" varchar(255) comment 'alert instance ids',
    "create_user_id"     integer comment 'create user id',
    "group_name"         varchar(255) comment 'group name',
    "description"        varchar(255),
    "create_time"        datetime comment 'create time',
    "update_time"        datetime comment 'update time',
    constraint PK primary key (ID)
);


alter table SYSDBA.T_DS_ALERTGROUP
    add constraint T_DS_ALERTGROUP_NAME_UN unique (GROUP_NAME);

create table SYSDBA.T_DS_ALERT_PLUGIN_INSTANCE
(
    "id"                     integer not null,
    "plugin_define_id"       integer not null,
    "plugin_instance_params" clob comment 'plugin instance params. Also contain the params value which user input in web ui.',
    "create_time"            timestamp default SYSDATE,
    "update_time"            timestamp default SYSDATE,
    "instance_name"          varchar(200) comment 'alert instance name'
);
alter table SYSDBA.T_DS_ALERT_PLUGIN_INSTANCE
    add constraint PK primary key (ID);

create table SYSDBA.T_DS_ALERT_SEND_STATUS
(
    "id"                       integer identity(1,1) not null,
    "alert_id"                 integer not null,
    "alert_plugin_instance_id" integer not null,
    "send_status"              tinyint default 0,
    "log"                      clob,
    "create_time"              datetime comment 'create time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_ALERT_SEND_STATUS
    add constraint ALERT_SEND_STATUS_UNIQUE unique (ALERT_ID, ALERT_PLUGIN_INSTANCE_ID);

create table SYSDBA.T_DS_AUDIT_LOG
(
    "id"            bigint identity(1,1) not null comment 'key',
    "user_id"       integer not null comment 'user id',
    "resource_type" integer not null comment 'resource type',
    "operation"     integer not null comment 'operation',
    "time"          datetime default "CURRENT_TIMESTAMP" comment 'create time',
    "resource_id"   integer comment 'resource id',
    constraint PK primary key (ID)
);


create table SYSDBA.T_DS_COMMAND
(
    "id"                         integer identity(1,1) not null comment 'key',
    "command_type"               tinyint comment 'Command type: 0 start workflow, 1 start execution from current node, 2 resume fault-tolerant workflow, 3 resume pause process, 4 start execution from failed node, 5 complement, 6 schedule, 7 rerun, 8 pause, 9 stop, 10 resume waiting thread',
    "process_definition_code"    bigint not null comment 'process definition code',
    "process_definition_version" integer default 0 comment 'process definition version',
    "process_instance_id"        integer default 0 comment 'process instance id',
    "command_param"              clob comment 'json command parameters',
    "task_depend_type"           tinyint comment 'Node dependency type: 0 current node, 1 forward, 2 backward',
    "failure_strategy"           tinyint default 0 comment 'Failed policy: 0 end, 1 continue',
    "warning_type"               tinyint default 0 comment 'Alarm type: 0 is not sent, 1 process is sent successfully, 2 process is sent failed, 3 process is sent successfully and all failures are sent',
    "warning_group_id"           integer comment 'warning group',
    "schedule_time"              datetime comment 'schedule time',
    "start_time"                 datetime comment 'start time',
    "executor_id"                integer comment 'executor id',
    "update_time"                datetime comment 'update time',
    "process_instance_priority"  integer default 2 comment 'process instance priority: 0 Highest,1 High,2 Medium,3 Low,4 Lowest',
    "worker_group"               varchar(64) comment 'worker group',
    "environment_code"           bigint  default - (1) comment 'environment code',
    "dry_run"                    tinyint default 0 comment 'dry run flag：0 normal, 1 dry run',
    constraint PK primary key (ID)
);
create index "PRIORITY_ID_INDEX" on SYSDBA.T_DS_COMMAND ("PROCESS_INSTANCE_PRIORITY", "ID") indextype is btree global;

create table SYSDBA.T_DS_DATASOURCE
(
    "id"                integer identity(1,1) not null comment 'key',
    "name"              varchar(64) not null comment 'data source name',
    "note"              varchar(255) comment 'description',
    "type"              tinyint     not null comment 'data source type: 0:mysql,1:postgresql,2:hive,3:spark',
    "user_id"           integer     not null comment 'the creator id',
    "connection_params" clob        not null comment 'json connection params',
    "create_time"       datetime    not null comment 'create time',
    "update_time"       datetime comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_DATASOURCE
    add constraint T_DS_DATASOURCE_NAME_UN unique (NAME, TYPE);

create table SYSDBA.T_DS_DQ_COMPARISON_TYPE
(
    "id"              integer identity(9,1) not null,
    "type"            varchar(100) not null,
    "execute_sql"     clob,
    "output_table"    varchar(100),
    "name"            varchar(100),
    "create_time"     datetime,
    "update_time"     datetime,
    "is_inner_source" tinyint default 0,
    constraint PK primary key (ID)
);


create table SYSDBA.T_DS_DQ_EXECUTE_RESULT
(
    "id"                    integer not null,
    "process_definition_id" integer,
    "process_instance_id"   integer,
    "task_instance_id"      integer,
    "rule_type"             integer,
    "rule_name"             varchar(255),
    "statistics_value"      double,
    "comparison_value"      double,
    "check_type"            integer,
    "threshold"             double,
    "operator"              integer,
    "failure_strategy"      integer,
    "state"                 integer,
    "user_id"               integer,
    "comparison_type"       integer,
    "error_output_path"     clob,
    "create_time"           datetime,
    "update_time"           datetime
);
alter table SYSDBA.T_DS_DQ_EXECUTE_RESULT
    add constraint PK primary key (ID);

create table SYSDBA.T_DS_DQ_RULE
(
    "id"          integer identity(11,1) not null,
    "name"        varchar(100),
    "type"        integer,
    "user_id"     integer,
    "create_time" datetime,
    "update_time" datetime,
    constraint PK primary key (ID)
);


create table SYSDBA.T_DS_DQ_RULE_EXECUTE_SQL
(
    "id"                  integer identity(18,1) not null,
    "index"               integer,
    "sql"                 clob,
    "table_alias"         varchar(255),
    "type"                integer,
    "is_error_output_sql" tinyint default 0,
    "create_time"         datetime,
    "update_time"         datetime,
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_DQ_RULE_INPUT_ENTRY
(
    "id"                 integer identity(30,1) not null,
    "field"              varchar(255),
    "type"               varchar(255),
    "title"              varchar(255),
    "value"              varchar(255),
    "options"            clob,
    "placeholder"        varchar(255),
    "option_source_type" integer,
    "value_type"         integer,
    "input_type"         integer,
    "is_show"            tinyint default 1,
    "can_edit"           tinyint default 1,
    "is_emit"            tinyint default 0,
    "is_validate"        tinyint default 1,
    "create_time"        datetime,
    "update_time"        datetime,
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_DQ_TASK_STATISTICS_VALUE
(
    "id"                    integer not null,
    "process_definition_id" integer,
    "task_instance_id"      integer,
    "rule_id"               integer not null,
    "unique_code"           varchar(255),
    "statistics_name"       varchar(255),
    "statistics_value"      double,
    "data_time"             datetime,
    "create_time"           datetime,
    "update_time"           datetime
);
alter table SYSDBA.T_DS_DQ_TASK_STATISTICS_VALUE
    add constraint PK primary key (ID);

create table SYSDBA.T_DS_ENVIRONMENT
(
    "id"          bigint identity(1,1) not null comment 'id',
    "code"        bigint comment 'encoding',
    "name"        varchar(100) not null comment 'environment name',
    "config"      clob comment 'this config contains many environment variables config',
    "description" clob comment 'the details',
    "operator"    integer comment 'operator user id',
    "create_time" timestamp default SYSDATE,
    "update_time" timestamp default SYSDATE,
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_ENVIRONMENT
    add constraint ENVIRONMENT_NAME_UNIQUE unique (NAME);
alter table SYSDBA.T_DS_ENVIRONMENT
    add constraint ENVIRONMENT_CODE_UNIQUE unique (CODE);

create table SYSDBA.T_DS_ENVIRONMENT_WORKER_GROUP_RELATION
(
    "id"               bigint identity(1,1) not null comment 'id',
    "environment_code" bigint       not null comment 'environment code',
    "worker_group"     varchar(255) not null comment 'worker group id',
    "operator"         integer comment 'operator user id',
    "create_time"      timestamp default SYSDATE,
    "update_time"      timestamp default SYSDATE,
    constraint PK primary key (ID)
);
alter table SYSDBA.T_DS_ENVIRONMENT_WORKER_GROUP_RELATION
    add constraint ENVIRONMENT_WORKER_GROUP_UNIQUE unique (ENVIRONMENT_CODE, WORKER_GROUP);

create table SYSDBA.T_DS_ERROR_COMMAND
(
    "id"                         integer not null comment 'key',
    "command_type"               tinyint comment 'command type',
    "executor_id"                integer comment 'executor id',
    "process_definition_code"    bigint  not null comment 'process definition code',
    "process_definition_version" integer default 0 comment 'process definition version',
    "process_instance_id"        integer default 0 comment 'process instance id: 0',
    "command_param"              clob comment 'json command parameters',
    "task_depend_type"           tinyint comment 'task depend type',
    "failure_strategy"           tinyint default 0 comment 'failure strategy',
    "warning_type"               tinyint default 0 comment 'warning type',
    "warning_group_id"           integer comment 'warning group id',
    "schedule_time"              datetime comment 'scheduler time',
    "start_time"                 datetime comment 'start time',
    "update_time"                datetime comment 'update time',
    "process_instance_priority"  integer default 2 comment 'process instance priority, 0 Highest,1 High,2 Medium,3 Low,4 Lowest',
    "worker_group"               varchar(64) comment 'worker group',
    "environment_code"           bigint  default - (1) comment 'environment code',
    "message"                    clob comment 'message',
    "dry_run"                    tinyint default 0 comment 'dry run flag: 0 normal, 1 dry run'
);
alter table SYSDBA.T_DS_ERROR_COMMAND
    add constraint PK primary key (ID);

create table SYSDBA.T_DS_K8S
(
    "id"          integer identity(1,1) not null,
    "k8s_name"    varchar(100),
    "k8s_config"  clob,
    "create_time" datetime comment 'create time',
    "update_time" datetime comment 'update time',
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_K8S_NAMESPACE
(
    "id"                 integer identity(1,1) not null,
    "limits_memory"      integer,
    "namespace"          varchar(100),
    "online_job_num"     integer,
    "user_id"            integer,
    "pod_replicas"       integer,
    "pod_request_cpu"    numeric(14, 3),
    "pod_request_memory" integer,
    "limits_cpu"         numeric(14, 3),
    "k8s"                varchar(100),
    "create_time"        datetime comment 'create time',
    "update_time"        datetime comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_K8S_NAMESPACE
    add constraint K8S_NAMESPACE_UNIQUE unique (NAMESPACE, K8S);

create table SYSDBA.T_DS_PLUGIN_DEFINE
(
    "id"            integer identity(2,1) not null,
    "plugin_name"   varchar(100) not null comment 'the name of plugin eg: email',
    "plugin_type"   varchar(100) not null comment 'plugin type . alert=alert plugin, job=job plugin',
    "plugin_params" clob comment 'plugin params',
    "create_time"   timestamp    not null default SYSDATE,
    "update_time"   timestamp    not null default SYSDATE,
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_PLUGIN_DEFINE
    add constraint T_DS_PLUGIN_DEFINE_UN unique (PLUGIN_NAME, PLUGIN_TYPE);

create table SYSDBA.T_DS_PROCESS_DEFINITION
(
    "id"               integer identity(1,1) not null comment 'self-increasing id',
    "code"             bigint   not null comment 'encoding',
    "name"             varchar(255) comment 'process definition name',
    "version"          integer           default 0 comment 'process definition version',
    "description"      clob comment 'description',
    "project_code"     bigint   not null comment 'project code',
    "release_state"    tinyint comment 'process definition release state：0:offline,1:online',
    "user_id"          integer comment 'process definition creator id',
    "global_params"    clob comment 'global parameters',
    "flag"             tinyint comment '0 not available, 1 available',
    "locations"        clob comment 'Node location information',
    "warning_group_id" integer comment 'alert group id',
    "timeout"          integer           default 0 comment 'time out, unit: minute',
    "tenant_id"        integer  not null default - (1) comment 'tenant id',
    "execution_type"   tinyint           default 0 comment 'execution_type 0:parallel,1:serial wait,2:serial discard,3:serial priority',
    "create_time"      datetime not null comment 'create time',
    "update_time"      datetime not null comment 'update time',
    constraint PK primary key (ID, CODE)
);

alter table SYSDBA.T_DS_PROCESS_DEFINITION
    add constraint PROCESS_UNIQUE unique (NAME, PROJECT_CODE);

create table SYSDBA.T_DS_PROCESS_DEFINITION_LOG
(
    "id"               integer identity(1,1) not null comment 'self-increasing id',
    "code"             bigint   not null comment 'encoding',
    "name"             varchar(200) comment 'process definition name',
    "version"          integer           default 0 comment 'process definition version',
    "description"      clob comment 'description',
    "project_code"     bigint   not null comment 'project code',
    "release_state"    tinyint comment 'process definition release state：0:offline,1:online',
    "user_id"          integer comment 'process definition creator id',
    "global_params"    clob comment 'global parameters',
    "flag"             tinyint comment '0 not available, 1 available',
    "locations"        clob comment 'Node location information',
    "warning_group_id" integer comment 'alert group id',
    "timeout"          integer           default 0 comment 'time out,unit: minute',
    "tenant_id"        integer  not null default - (1) comment 'tenant id',
    "execution_type"   tinyint           default 0 comment 'execution_type 0:parallel,1:serial wait,2:serial discard,3:serial priority',
    "operator"         integer comment 'operator user id',
    "operate_time"     datetime comment 'operate time',
    "create_time"      datetime not null comment 'create time',
    "update_time"      datetime not null comment 'update time',
    constraint PK primary key (ID)
);


create table SYSDBA.T_DS_PROCESS_INSTANCE
(
    "id"                         integer identity(1,1) not null comment 'key',
    "name"                       varchar(255) comment 'process instance name',
    "process_definition_code"    bigint  not null comment 'process definition code',
    "process_definition_version" integer          default 0 comment 'process definition version',
    "state"                      tinyint comment 'process instance Status: 0 commit succeeded, 1 running, 2 prepare to pause, 3 pause, 4 prepare to stop, 5 stop, 6 fail, 7 succeed, 8 need fault tolerance, 9 kill, 10 wait for thread, 11 wait for dependency to complete',
    "recovery"                   tinyint comment 'process instance failover flag：0:normal,1:failover instance',
    "start_time"                 datetime comment 'process instance start time',
    "end_time"                   datetime comment 'process instance end time',
    "run_times"                  integer comment 'process instance run times',
    "host"                       varchar(135) comment 'process instance host',
    "command_type"               tinyint comment 'command type',
    "command_param"              clob comment 'json command parameters',
    "task_depend_type"           tinyint comment 'task depend type. 0: only current node,1:before the node,2:later nodes',
    "max_try_times"              tinyint          default 0 comment 'max try times',
    "failure_strategy"           tinyint          default 0 comment 'failure strategy. 0:end the process when node failed,1:continue running the other nodes when node failed',
    "warning_type"               tinyint          default 0 comment 'warning type. 0:no warning,1:warning if process success,2:warning if process failed,3:warning if success',
    "warning_group_id"           integer comment 'warning group id',
    "schedule_time"              datetime comment 'schedule time',
    "command_start_time"         datetime comment 'command start time',
    "global_params"              clob comment 'global parameters',
    "flag"                       tinyint          default 1 comment 'flag',
    "update_time"                timestamp        default SYSDATE,
    "is_sub_process"             integer          default 0 comment 'flag, whether the process is sub process',
    "executor_id"                integer not null comment 'executor id',
    "history_cmd"                clob comment 'history commands of process instance operation',
    "process_instance_priority"  integer          default 2 comment 'process instance priority. 0 Highest,1 High,2 Medium,3 Low,4 Lowest',
    "worker_group"               varchar(64) comment 'worker group id',
    "environment_code"           bigint           default - (1) comment 'environment code',
    "timeout"                    integer          default 0 comment 'time out',
    "tenant_id"                  integer not null default - (1) comment 'tenant id',
    "var_pool"                   clob comment 'var_pool',
    "dry_run"                    tinyint          default 0 comment 'dry run flag：0 normal, 1 dry run',
    "next_process_instance_id"   integer          default 0 comment 'serial queue next processInstanceId',
    "restart_time"               datetime comment 'process instance restart time',
    constraint PK primary key (ID)
);

create index "PROCESS_INSTANCE_INDEX" on SYSDBA.T_DS_PROCESS_INSTANCE ("PROCESS_DEFINITION_CODE", "ID") indextype is btree global;
create index "START_TIME_INDEX" on SYSDBA.T_DS_PROCESS_INSTANCE ("START_TIME", "END_TIME") indextype is btree global;

create table SYSDBA.T_DS_PROCESS_TASK_RELATION
(
    "id"                         integer identity(1,1) not null comment 'self-increasing id',
    "name"                       varchar(200) comment 'relation name',
    "project_code"               bigint   not null comment 'project code',
    "process_definition_code"    bigint   not null comment 'process code',
    "process_definition_version" integer  not null comment 'process version',
    "pre_task_code"              bigint   not null comment 'pre task code',
    "pre_task_version"           integer  not null comment 'pre task version',
    "post_task_code"             bigint   not null comment 'post task code',
    "post_task_version"          integer  not null comment 'post task version',
    "condition_type"             tinyint comment 'condition type : 0 none, 1 judge 2 delay',
    "condition_params"           clob comment 'condition params(json)',
    "create_time"                datetime not null comment 'create time',
    "update_time"                datetime not null comment 'update time',
    constraint PK primary key (ID)
);

create index "IDX_CODE" on SYSDBA.T_DS_PROCESS_TASK_RELATION ("PROJECT_CODE", "PROCESS_DEFINITION_CODE") indextype is btree global;
create index "IDX_POST_TASK_CODE_VERSION" on SYSDBA.T_DS_PROCESS_TASK_RELATION ("POST_TASK_CODE", "POST_TASK_VERSION") indextype is btree global;
create index "IDX_PRE_TASK_CODE_VERSION" on SYSDBA.T_DS_PROCESS_TASK_RELATION ("PRE_TASK_CODE", "PRE_TASK_VERSION") indextype is btree global;

create table SYSDBA.T_DS_PROCESS_TASK_RELATION_LOG
(
    "id"                         integer identity(1,1) not null comment 'self-increasing id',
    "name"                       varchar(200) comment 'relation name',
    "project_code"               bigint   not null comment 'project code',
    "process_definition_code"    bigint   not null comment 'process code',
    "process_definition_version" integer  not null comment 'process version',
    "pre_task_code"              bigint   not null comment 'pre task code',
    "pre_task_version"           integer  not null comment 'pre task version',
    "post_task_code"             bigint   not null comment 'post task code',
    "post_task_version"          integer  not null comment 'post task version',
    "condition_type"             tinyint comment 'condition type : 0 none, 1 judge 2 delay',
    "condition_params"           clob comment 'condition params(json)',
    "operator"                   integer comment 'operator user id',
    "operate_time"               datetime comment 'operate time',
    "create_time"                datetime not null comment 'create time',
    "update_time"                datetime not null comment 'update time',
    constraint PK primary key (ID)
);

create index "IDX_PROCESS_CODE_VERSION" on SYSDBA.T_DS_PROCESS_TASK_RELATION_LOG ("PROCESS_DEFINITION_CODE", "PROCESS_DEFINITION_VERSION") indextype is btree global;

create table SYSDBA.T_DS_PROJECT
(
    "id"          integer identity(1,1) not null comment 'key',
    "name"        varchar(100) comment 'project name',
    "code"        bigint   not null comment 'encoding',
    "description" varchar(200),
    "user_id"     integer comment 'creator id',
    "flag"        tinyint default 1 comment '0 not available, 1 available',
    "create_time" datetime not null comment 'create time',
    "update_time" datetime comment 'update time',
    constraint PK primary key (ID)
);


alter table SYSDBA.T_DS_PROJECT
    add constraint UNIQUE_NAME unique (NAME);

alter table SYSDBA.T_DS_PROJECT
    add constraint UNIQUE_CODE unique (CODE);
create index "USER_ID_INDEX" on SYSDBA.T_DS_PROJECT ("USER_ID") indextype is btree global;

create table SYSDBA.T_DS_QUEUE
(
    "id"          integer identity(2,1) not null comment 'key',
    "queue_name"  varchar(64) comment 'queue name',
    "queue"       varchar(64) comment 'yarn queue name',
    "create_time" datetime comment 'create time',
    "update_time" datetime comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_QUEUE
    add constraint UNIQUE_QUEUE_NAME unique (QUEUE_NAME);

create table SYSDBA.T_DS_RELATION_DATASOURCE_USER
(
    "id"            integer identity(1,1) not null comment 'key',
    "user_id"       integer not null comment 'user id',
    "datasource_id" integer comment 'data source id',
    "perm"          integer default 1 comment 'limits of authority',
    "create_time"   datetime comment 'create time',
    "update_time"   datetime comment 'update time',
    constraint PK primary key (ID)
);


create table SYSDBA.T_DS_RELATION_NAMESPACE_USER
(
    "id"           integer identity(1,1) not null comment 'key',
    "user_id"      integer not null comment 'user id',
    "namespace_id" integer comment 'namespace id',
    "perm"         integer default 1 comment 'limits of authority',
    "create_time"  datetime comment 'create time',
    "update_time"  datetime comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_RELATION_NAMESPACE_USER
    add constraint NAMESPACE_USER_UNIQUE unique (USER_ID, NAMESPACE_ID);

create table SYSDBA.T_DS_RELATION_PROCESS_INSTANCE
(
    "id"                         integer identity(1,1) not null comment 'key',
    "parent_process_instance_id" integer comment 'parent process instance id',
    "parent_task_instance_id"    integer comment 'parent process instance id',
    "process_instance_id"        integer comment 'child process instance id',
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_RELATION_PROJECT_USER
(
    "id"          integer identity(1,1) not null comment 'key',
    "user_id"     integer not null comment 'user id',
    "project_id"  integer comment 'project id',
    "perm"        integer default 1 comment 'limits of authority',
    "create_time" datetime comment 'create time',
    "update_time" datetime comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_RELATION_PROJECT_USER
    add constraint UNIQ_UID_PID unique (USER_ID, PROJECT_ID);

create table SYSDBA.T_DS_RELATION_RESOURCES_USER
(
    "id"           integer identity(1,1) not null,
    "user_id"      integer not null comment 'user id',
    "resources_id" integer comment 'resource id',
    "perm"         integer default 1 comment 'limits of authority',
    "create_time"  datetime comment 'create time',
    "update_time"  datetime comment 'update time',
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_RELATION_RULE_EXECUTE_SQL
(
    "id"             integer identity(16,1) not null,
    "rule_id"        integer,
    "execute_sql_id" integer,
    "create_time"    datetime,
    "update_time"    datetime,
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_RELATION_RULE_INPUT_ENTRY
(
    "id"                  integer identity(151,1) not null,
    "rule_id"             integer,
    "rule_input_entry_id" integer,
    "values_map"          clob,
    "index"               integer,
    "create_time"         datetime,
    "update_time"         datetime,
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_RELATION_UDFS_USER
(
    "id"          integer identity(1,1) not null comment 'key',
    "user_id"     integer not null comment 'userid',
    "udf_id"      integer comment 'udf id',
    "perm"        integer default 1 comment 'limits of authority',
    "create_time" datetime comment 'create time',
    "update_time" datetime comment 'update time',
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_RESOURCES
(
    "id"           integer identity(1,1) not null comment 'key',
    "alias"        varchar(64) comment 'alias',
    "file_name"    varchar(64) comment 'file name',
    "description"  varchar(255),
    "user_id"      integer comment 'user id',
    "type"         tinyint comment 'resource type,0:FILE，1:UDF',
    "size"         bigint comment 'resource size',
    "create_time"  datetime comment 'create time',
    "update_time"  datetime comment 'update time',
    "pid"          integer,
    "full_name"    varchar(128),
    "is_directory" tinyint,
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_RESOURCES
    add constraint T_DS_RESOURCES_UN unique (FULL_NAME, TYPE);

create table SYSDBA.T_DS_SCHEDULES
(
    "id"                        integer identity(1,1) not null comment 'key',
    "process_definition_code"   bigint       not null comment 'process definition code',
    "start_time"                datetime     not null comment 'start time',
    "end_time"                  datetime     not null comment 'end time',
    "timezone_id"               varchar(40) comment 'schedule timezone id',
    "crontab"                   varchar(255) not null comment 'crontab description',
    "failure_strategy"          tinyint      not null comment 'failure strategy. 0:end,1:continue',
    "user_id"                   integer      not null comment 'user id',
    "release_state"             tinyint      not null comment 'release state. 0:offline,1:online',
    "warning_type"              tinyint      not null comment 'Alarm type: 0 is not sent, 1 process is sent successfully, 2 process is sent failed, 3 process is sent successfully and all failures are sent',
    "warning_group_id"          integer comment 'alert group id',
    "process_instance_priority" integer     default 2 comment 'process instance priority：0 Highest,1 High,2 Medium,3 Low,4 Lowest',
    "worker_group"              varchar(64) default '' comment 'worker group id',
    "environment_code"          bigint      default - (1) comment 'environment code',
    "create_time"               datetime     not null comment 'create time',
    "update_time"               datetime     not null comment 'update time',
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_SESSION
(
    "id"              varchar(64) not null comment 'key',
    "user_id"         integer comment 'user id',
    "ip"              varchar(45) comment 'ip',
    "last_login_time" datetime comment 'last login time'
);
alter table SYSDBA.T_DS_SESSION
    add constraint PK primary key (ID);

create table SYSDBA.T_DS_TASK_DEFINITION
(
    "id"                      integer identity(1,1) not null comment 'self-increasing id',
    "code"                    bigint      not null comment 'encoding',
    "name"                    varchar(200) comment 'task definition name',
    "version"                 integer default 0 comment 'task definition version',
    "description"             clob comment 'description',
    "project_code"            bigint      not null comment 'project code',
    "user_id"                 integer comment 'task definition creator id',
    "task_type"               varchar(50) not null comment 'task type',
    "task_params"             clob comment 'job custom parameters',
    "flag"                    tinyint comment '0 not available, 1 available',
    "task_priority"           tinyint default 2 comment 'job priority',
    "worker_group"            varchar(200) comment 'worker grouping',
    "environment_code"        bigint  default - (1) comment 'environment code',
    "fail_retry_times"        integer comment 'number of failed retries',
    "fail_retry_interval"     integer comment 'failed retry interval',
    "timeout_flag"            tinyint default 0 comment 'timeout flag:0 close, 1 open',
    "timeout_notify_strategy" tinyint comment 'timeout notification policy: 0 warning, 1 fail',
    "timeout"                 integer default 0 comment 'timeout length,unit: minute',
    "delay_time"              integer default 0 comment 'delay execution time,unit: minute',
    "resource_ids"            clob comment 'resource id, separated by comma',
    "task_group_id"           integer comment 'task group id',
    "task_group_priority"     tinyint default 0 comment 'task group priority',
    "create_time"             datetime    not null comment 'create time',
    "update_time"             datetime    not null comment 'update time',
    constraint PK primary key (ID, CODE)
);


create table SYSDBA.T_DS_TASK_DEFINITION_LOG
(
    "id"                      integer identity(1,1) not null comment 'self-increasing id',
    "code"                    bigint      not null comment 'encoding',
    "name"                    varchar(200) comment 'task definition name',
    "version"                 integer default 0 comment 'task definition version',
    "description"             clob comment 'description',
    "project_code"            bigint      not null comment 'project code',
    "user_id"                 integer comment 'task definition creator id',
    "task_type"               varchar(50) not null comment 'task type',
    "task_params"             clob comment 'job custom parameters',
    "flag"                    tinyint comment '0 not available, 1 available',
    "task_priority"           tinyint default 2 comment 'job priority',
    "worker_group"            varchar(200) comment 'worker grouping',
    "environment_code"        bigint  default - (1) comment 'environment code',
    "fail_retry_times"        integer comment 'number of failed retries',
    "fail_retry_interval"     integer comment 'failed retry interval',
    "timeout_flag"            tinyint default 0 comment 'timeout flag:0 close, 1 open',
    "timeout_notify_strategy" tinyint comment 'timeout notification policy: 0 warning, 1 fail',
    "timeout"                 integer default 0 comment 'timeout length,unit: minute',
    "delay_time"              integer default 0 comment 'delay execution time,unit: minute',
    "resource_ids"            clob comment 'resource id, separated by comma',
    "operator"                integer comment 'operator user id',
    "task_group_id"           integer comment 'task group id',
    "task_group_priority"     tinyint default 0 comment 'task group priority',
    "operate_time"            datetime comment 'operate time',
    "create_time"             datetime    not null comment 'create time',
    "update_time"             datetime    not null comment 'update time',
    constraint PK primary key (ID)
);

create index "IDX_CODE_VERSION" on SYSDBA.T_DS_TASK_DEFINITION_LOG ("CODE", "VERSION") indextype is btree global;
create index "IDX_PROJECT_CODE" on SYSDBA.T_DS_TASK_DEFINITION_LOG ("PROJECT_CODE") indextype is btree global;

create table SYSDBA.T_DS_TASK_GROUP
(
    "id"           integer identity(1,1) not null comment 'key',
    "name"         varchar(100) comment 'task_group name',
    "description"  varchar(200),
    "group_size"   integer not null comment 'group size',
    "use_size"     integer   default 0 comment 'used size',
    "user_id"      integer comment 'creator id',
    "project_code" bigint    default 0 comment 'project code',
    "status"       tinyint   default 1 comment '0 not available, 1 available',
    "create_time"  timestamp default SYSDATE,
    "update_time"  timestamp default SYSDATE,
    constraint PK primary key (ID)
);


create table SYSDBA.T_DS_TASK_GROUP_QUEUE
(
    "id"          integer identity(1,1) not null comment 'key',
    "task_id"     integer comment 'taskintanceid',
    "task_name"   varchar(100) comment 'TaskInstance name',
    "group_id"    integer comment 'taskGroup id',
    "process_id"  integer comment 'processInstace id',
    "priority"    integer   default 0 comment 'priority',
    "status"      tinyint   default - (1) comment '-1: waiting  1: running  2: finished',
    "force_start" tinyint   default 0 comment 'is force start 0 NO ,1 YES',
    "in_queue"    tinyint   default 0 comment 'ready to get the queue by other task finish 0 NO ,1 YES',
    "create_time" timestamp default SYSDATE,
    "update_time" timestamp default SYSDATE,
    constraint PK primary key (ID)
);

create table SYSDBA.T_DS_TASK_INSTANCE
(
    "id"                      integer identity(1,1) not null comment 'key',
    "name"                    varchar(255) comment 'task name',
    "task_type"               varchar(50) not null comment 'task type',
    "task_code"               bigint      not null comment 'task definition code',
    "task_definition_version" integer default 0 comment 'task definition version',
    "process_instance_id"     integer comment 'process instance id',
    "state"                   tinyint comment 'Status: 0 commit succeeded, 1 running, 2 prepare to pause, 3 pause, 4 prepare to stop, 5 stop, 6 fail, 7 succeed, 8 need fault tolerance, 9 kill, 10 wait for thread, 11 wait for dependency to complete',
    "submit_time"             datetime comment 'task submit time',
    "start_time"              datetime comment 'task start time',
    "end_time"                datetime comment 'task end time',
    "host"                    varchar(135) comment 'host of task running on',
    "execute_path"            varchar(200) comment 'task execute path in the host',
    "log_path"                clob comment 'task log path',
    "alert_flag"              tinyint comment 'whether alert',
    "retry_times"             integer default 0 comment 'task retry times',
    "pid"                     integer comment 'pid of task',
    "app_link"                clob comment 'yarn app id',
    "task_params"             clob comment 'job custom parameters',
    "flag"                    tinyint default 1 comment '0 not available, 1 available',
    "retry_interval"          integer comment 'retry interval when task failed',
    "max_retry_times"         integer comment 'max retry times',
    "task_instance_priority"  integer comment 'task instance priority:0 Highest,1 High,2 Medium,3 Low,4 Lowest',
    "worker_group"            varchar(64) comment 'worker group id',
    "environment_code"        bigint  default - (1) comment 'environment code',
    "environment_config"      clob comment 'this config contains many environment variables config',
    "executor_id"             integer,
    "first_submit_time"       datetime comment 'task first submit time',
    "delay_time"              integer default 0 comment 'task delay execution time',
    "var_pool"                clob comment 'var_pool',
    "task_group_id"           integer comment 'task group id',
    "dry_run"                 tinyint default 0 comment 'dry run flag: 0 normal, 1 dry run',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_TASK_INSTANCE
    add constraint FOREIGN_KEY_INSTANCE_ID foreign key (PROCESS_INSTANCE_ID) references SYSDBA.T_DS_PROCESS_INSTANCE (ID) on update no action on delete cascade;
create index "IDX_CODE_VERSION" on SYSDBA.T_DS_TASK_INSTANCE ("TASK_CODE", "TASK_DEFINITION_VERSION") indextype is btree global;
create index "PROCESS_INSTANCE_ID" on SYSDBA.T_DS_TASK_INSTANCE ("PROCESS_INSTANCE_ID") indextype is btree global;

create table SYSDBA.T_DS_TENANT
(
    "id"          integer identity(1,1) not null comment 'key',
    "tenant_code" varchar(64) comment 'tenant code',
    "description" varchar(255),
    "queue_id"    integer comment 'queue id',
    "create_time" datetime comment 'create time',
    "update_time" datetime comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_TENANT
    add constraint UNIQUE_TENANT_CODE unique (TENANT_CODE);

create table SYSDBA.T_DS_UDFS
(
    "id"            integer identity(1,1) not null comment 'key',
    "user_id"       integer      not null comment 'user id',
    "func_name"     varchar(100) not null comment 'UDF function name',
    "class_name"    varchar(255) not null comment 'class of udf',
    "type"          tinyint      not null comment 'Udf function type',
    "arg_types"     varchar(255) comment 'arguments types',
    "database"      varchar(255) comment 'data base',
    "description"   varchar(255),
    "resource_id"   integer      not null comment 'resource id',
    "resource_name" varchar(255) not null comment 'resource name',
    "create_time"   datetime     not null comment 'create time',
    "update_time"   datetime     not null comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_UDFS
    add constraint UNIQUE_FUNC_NAME unique (FUNC_NAME);

create table SYSDBA.T_DS_USER
(
    "id"            integer identity(2,1) not null comment 'user id',
    "user_name"     varchar(64) comment 'user name',
    "user_password" varchar(64) comment 'user password',
    "user_type"     tinyint comment 'user type, 0:administrator，1:ordinary user',
    "email"         varchar(64) comment 'email',
    "phone"         varchar(11) comment 'phone',
    "tenant_id"     integer comment 'tenant id',
    "create_time"   datetime comment 'create time',
    "update_time"   datetime comment 'update time',
    "queue"         varchar(64) comment 'queue',
    "state"         tinyint default 1 comment 'state 0:disable 1:enable',
    "time_zone"     varchar(32) comment 'time zone',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_USER
    add constraint USER_NAME_UNIQUE unique (USER_NAME);

create table SYSDBA.T_DS_VERSION
(
    "id"      integer identity(2,1) not null,
    "version" varchar(200) not null,
    constraint PK primary key (ID)
) comment 'version';

alter table SYSDBA.T_DS_VERSION
    add constraint VERSION_UNIQUE unique (VERSION);

create table SYSDBA.T_DS_WORKER_GROUP
(
    "id"          bigint identity(1,1) not null comment 'id',
    "name"        varchar(255) not null comment 'worker group name',
    "addr_list"   clob comment 'worker addr list. split by [,]',
    "create_time" datetime comment 'create time',
    "update_time" datetime comment 'update time',
    constraint PK primary key (ID)
);

alter table SYSDBA.T_DS_WORKER_GROUP
    add constraint NAME_UNIQUE unique (NAME);



INSERT INTO t_ds_alertgroup (id, alert_instance_ids, create_user_id, group_name, description, create_time, update_time) VALUES (1, '1,2', 1, 'default admin warning group', 'default admin warning group', '2018-11-29 10:20:39', '2018-11-29 10:20:39');


INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (1, 'FixValue', null, null, null, '2021-06-30 00:00:00', '2021-06-30 00:00:00', 0);
INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (2, 'DailyAvg', 'select round(avg(statistics_value),2) as day_avg from t_ds_dq_task_statistics_value where data_time >=date_trunc(''DAY'', ${data_time}) and data_time < date_add(date_trunc(''day'', ${data_time}),1) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''', 'day_range', 'day_range.day_avg', '2021-06-30 00:00:00', '2021-06-30 00:00:00', 1);
INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (3, 'WeeklyAvg', 'select round(avg(statistics_value),2) as week_avg from t_ds_dq_task_statistics_value where  data_time >= date_trunc(''WEEK'', ${data_time}) and data_time <date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''', 'week_range', 'week_range.week_avg', '2021-06-30 00:00:00', '2021-06-30 00:00:00', 1);
INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (4, 'MonthlyAvg', 'select round(avg(statistics_value),2) as month_avg from t_ds_dq_task_statistics_value where  data_time >= date_trunc(''MONTH'', ${data_time}) and data_time <date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''', 'month_range', 'month_range.month_avg', '2021-06-30 00:00:00', '2021-06-30 00:00:00', 1);
INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (5, 'Last7DayAvg', 'select round(avg(statistics_value),2) as last_7_avg from t_ds_dq_task_statistics_value where  data_time >= date_add(date_trunc(''day'', ${data_time}),-7) and  data_time <date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''', 'last_seven_days', 'last_seven_days.last_7_avg', '2021-06-30 00:00:00', '2021-06-30 00:00:00', 1);
INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (6, 'Last30DayAvg', 'select round(avg(statistics_value),2) as last_30_avg from t_ds_dq_task_statistics_value where  data_time >= date_add(date_trunc(''day'', ${data_time}),-30) and  data_time < date_trunc(''day'', ${data_time}) and unique_code = ${unique_code} and statistics_name = ''${statistics_name}''', 'last_thirty_days', 'last_thirty_days.last_30_avg', '2021-06-30 00:00:00', '2021-06-30 00:00:00', 1);
INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (7, 'SrcTableTotalRows', 'SELECT COUNT(*) AS total FROM ${src_table} WHERE (${src_filter})', 'total_count', 'total_count.total', '2021-06-30 00:00:00', '2021-06-30 00:00:00', 0);
INSERT INTO t_ds_dq_comparison_type (id, type, execute_sql, output_table, name, create_time, update_time, is_inner_source) VALUES (8, 'TargetTableTotalRows', 'SELECT COUNT(*) AS total FROM ${target_table} WHERE (${target_filter})', 'total_count', 'total_count.total', '2021-06-30 00:00:00', '2021-06-30 00:00:00', 0);


INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (1, '$t(null_check)', 0, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (2, '$t(custom_sql)', 1, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (3, '$t(multi_table_accuracy)', 2, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (4, '$t(multi_table_value_comparison)', 3, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (5, '$t(field_length_check)', 0, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (6, '$t(uniqueness_check)', 0, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (7, '$t(regexp_check)', 0, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (8, '$t(timeliness_check)', 0, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (9, '$t(enumeration_check)', 0, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');
INSERT INTO t_ds_dq_rule (id, name, type, user_id, create_time, update_time) VALUES (10, '$t(table_count_check)', 0, 1, '2020-01-12 00:00:00', '2020-01-12 00:00:00');

INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (1, 1, 'SELECT COUNT(*) AS nulls FROM null_items', 'null_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (2, 1, 'SELECT COUNT(*) AS total FROM ${src_table} WHERE (${src_filter})', 'total_count', 2, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (3, 1, 'SELECT COUNT(*) AS miss from miss_items', 'miss_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (4, 1, 'SELECT COUNT(*) AS valids FROM invalid_length_items', 'invalid_length_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (5, 1, 'SELECT COUNT(*) AS total FROM ${target_table} WHERE (${target_filter})', 'total_count', 2, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (6, 1, 'SELECT ${src_field} FROM ${src_table} group by ${src_field} having count(*) > 1', 'duplicate_items', 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (7, 1, 'SELECT COUNT(*) AS duplicates FROM duplicate_items', 'duplicate_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (8, 1, 'SELECT ${src_table}.* FROM (SELECT * FROM ${src_table} WHERE (${src_filter})) ${src_table} LEFT JOIN (SELECT * FROM ${target_table} WHERE (${target_filter})) ${target_table} ON ${on_clause} WHERE ${where_clause}', 'miss_items', 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (9, 1, 'SELECT * FROM ${src_table} WHERE (${src_field} not regexp ''${regexp_pattern}'') AND (${src_filter}) ', 'regexp_items', 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (10, 1, 'SELECT COUNT(*) AS regexps FROM regexp_items', 'regexp_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (11, 1, 'SELECT * FROM ${src_table} WHERE (to_unix_timestamp(${src_field}, ''${datetime_format}'')-to_unix_timestamp(''${deadline}'', ''${datetime_format}'') <= 0) AND (to_unix_timestamp(${src_field}, ''${datetime_format}'')-to_unix_timestamp(''${begin_time}'', ''${datetime_format}'') >= 0) AND (${src_filter}) ', 'timeliness_items', 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (12, 1, 'SELECT COUNT(*) AS timeliness FROM timeliness_items', 'timeliness_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (13, 1, 'SELECT * FROM ${src_table} where (${src_field} not in ( ${enum_list} ) or ${src_field} is null) AND (${src_filter}) ', 'enum_items', 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (14, 1, 'SELECT COUNT(*) AS enums FROM enum_items', 'enum_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (15, 1, 'SELECT COUNT(*) AS total FROM ${src_table} WHERE (${src_filter})', 'table_count', 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (16, 1, 'SELECT * FROM ${src_table} WHERE (${src_field} is null or ${src_field} = '''') AND (${src_filter})', 'null_items', 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_execute_sql (id, `index`, `sql`, table_alias, type, is_error_output_sql, create_time, update_time) VALUES (17, 1, 'SELECT * FROM ${src_table} WHERE (length(${src_field}) ${logic_operator} ${field_length}) AND (${src_filter})', 'invalid_length_items', 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');

INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (1, 'src_connector_type', 'select', '$t(src_connector_type)', '', '[{"label":"HIVE","value":"HIVE"},{"label":"JDBC","value":"JDBC"}]', 'please select source connector type', 2, 2, 0, 1, 1, 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (2, 'src_datasource_id', 'select', '$t(src_datasource_id)', '', null, 'please select source datasource id', 1, 2, 0, 1, 1, 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (3, 'src_table', 'select', '$t(src_table)', null, null, 'Please enter source table name', 0, 0, 0, 1, 1, 1, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (4, 'src_filter', 'input', '$t(src_filter)', null, null, 'Please enter filter expression', 0, 3, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (5, 'src_field', 'select', '$t(src_field)', null, null, 'Please enter column, only single column is supported', 0, 0, 0, 1, 1, 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (6, 'statistics_name', 'input', '$t(statistics_name)', null, null, 'Please enter statistics name, the alias in statistics execute sql', 0, 0, 1, 0, 0, 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (7, 'check_type', 'select', '$t(check_type)', '0', '[{"label":"Expected - Actual","value":"0"},{"label":"Actual - Expected","value":"1"},{"label":"Actual / Expected","value":"2"},{"label":"(Expected - Actual) / Expected","value":"3"}]', 'please select check type', 0, 0, 3, 1, 1, 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (8, 'operator', 'select', '$t(operator)', '0', '[{"label":"=","value":"0"},{"label":"<","value":"1"},{"label":"<=","value":"2"},{"label":">","value":"3"},{"label":">=","value":"4"},{"label":"!=","value":"5"}]', 'please select operator', 0, 0, 3, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (9, 'threshold', 'input', '$t(threshold)', null, null, 'Please enter threshold, number is needed', 0, 2, 3, 1, 1, 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (10, 'failure_strategy', 'select', '$t(failure_strategy)', '0', '[{"label":"Alert","value":"0"},{"label":"Block","value":"1"}]', 'please select failure strategy', 0, 0, 3, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (11, 'target_connector_type', 'select', '$t(target_connector_type)', '', '[{"label":"HIVE","value":"HIVE"},{"label":"JDBC","value":"JDBC"}]', 'Please select target connector type', 2, 0, 0, 1, 1, 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (12, 'target_datasource_id', 'select', '$t(target_datasource_id)', '', null, 'Please select target datasource', 1, 2, 0, 1, 1, 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (13, 'target_table', 'select', '$t(target_table)', null, null, 'Please enter target table', 0, 0, 0, 1, 1, 1, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (14, 'target_filter', 'input', '$t(target_filter)', null, null, 'Please enter target filter expression', 0, 3, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (15, 'mapping_columns', 'group', '$t(mapping_columns)', null, '[{"field":"src_field","props":{"placeholder":"Please input src field","rows":0,"disabled":false,"size":"small"},"type":"input","title":"src_field"},{"field":"operator","props":{"placeholder":"Please input operator","rows":0,"disabled":false,"size":"small"},"type":"input","title":"operator"},{"field":"target_field","props":{"placeholder":"Please input target field","rows":0,"disabled":false,"size":"small"},"type":"input","title":"target_field"}]', 'please enter mapping columns', 0, 0, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (16, 'statistics_execute_sql', 'textarea', '$t(statistics_execute_sql)', null, null, 'Please enter statistics execute sql', 0, 3, 0, 1, 1, 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (17, 'comparison_name', 'input', '$t(comparison_name)', null, null, 'Please enter comparison name, the alias in comparison execute sql', 0, 0, 0, 0, 0, 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (18, 'comparison_execute_sql', 'textarea', '$t(comparison_execute_sql)', null, null, 'Please enter comparison execute sql', 0, 3, 0, 1, 1, 0, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (19, 'comparison_type', 'select', '$t(comparison_type)', '', null, 'Please enter comparison title', 3, 0, 2, 1, 0, 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (20, 'writer_connector_type', 'select', '$t(writer_connector_type)', '', '[{"label":"MYSQL","value":"0"},{"label":"POSTGRESQL","value":"1"}]', 'please select writer connector type', 0, 2, 0, 1, 1, 1, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (21, 'writer_datasource_id', 'select', '$t(writer_datasource_id)', '', null, 'please select writer datasource id', 1, 2, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (22, 'target_field', 'select', '$t(target_field)', null, null, 'Please enter column, only single column is supported', 0, 0, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (23, 'field_length', 'input', '$t(field_length)', null, null, 'Please enter length limit', 0, 3, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (24, 'logic_operator', 'select', '$t(logic_operator)', '=', '[{"label":"=","value":"="},{"label":"<","value":"<"},{"label":"<=","value":"<="},{"label":">","value":">"},{"label":">=","value":">="},{"label":"<>","value":"<>"}]', 'please select logic operator', 0, 0, 3, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (25, 'regexp_pattern', 'input', '$t(regexp_pattern)', null, null, 'Please enter regexp pattern', 0, 0, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (26, 'deadline', 'input', '$t(deadline)', null, null, 'Please enter deadline', 0, 0, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (27, 'datetime_format', 'input', '$t(datetime_format)', null, null, 'Please enter datetime format', 0, 0, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (28, 'enum_list', 'input', '$t(enum_list)', null, null, 'Please enter enumeration', 0, 0, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_dq_rule_input_entry (id, field, type, title, value, options, placeholder, option_source_type, value_type, input_type, is_show, can_edit, is_emit, is_validate, create_time, update_time) VALUES (29, 'begin_time', 'input', '$t(begin_time)', null, null, 'Please enter begin time', 0, 0, 0, 1, 1, 0, 0, '2021-03-03 11:31:24', '2021-03-03 11:31:24');


INSERT INTO t_ds_queue (id, queue_name, queue, create_time, update_time) VALUES (1, 'default', 'default', null, null);


INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (1, 1, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (2, 3, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (3, 5, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (4, 3, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (5, 6, 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (6, 6, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (7, 7, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (8, 7, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (9, 8, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (10, 8, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (11, 9, 13, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (12, 9, 14, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (13, 10, 15, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (14, 1, 16, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_execute_sql (id, rule_id, execute_sql_id, create_time, update_time) VALUES (15, 5, 17, '2021-03-03 11:31:24', '2021-03-03 11:31:24');

INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (1, 1, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (2, 1, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (3, 1, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (4, 1, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (5, 1, 5, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (6, 1, 6, '{"statistics_name":"null_count.nulls"}', 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (7, 1, 7, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (8, 1, 8, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (9, 1, 9, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (10, 1, 10, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (11, 1, 17, '', 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (12, 1, 19, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (13, 2, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (14, 2, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (15, 2, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (16, 2, 6, '{"is_show":"true","can_edit":"true"}', 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (17, 2, 16, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (18, 2, 4, null, 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (19, 2, 7, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (20, 2, 8, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (21, 2, 9, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (22, 2, 10, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (24, 2, 19, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (25, 3, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (26, 3, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (27, 3, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (28, 3, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (29, 3, 11, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (30, 3, 12, null, 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (31, 3, 13, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (32, 3, 14, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (33, 3, 15, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (34, 3, 7, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (35, 3, 8, null, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (36, 3, 9, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (37, 3, 10, null, 13, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (38, 3, 17, '{"comparison_name":"total_count.total"}', 14, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (39, 3, 19, null, 15, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (40, 4, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (41, 4, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (42, 4, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (43, 4, 6, '{"is_show":"true","can_edit":"true"}', 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (44, 4, 16, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (45, 4, 11, null, 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (46, 4, 12, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (47, 4, 13, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (48, 4, 17, '{"is_show":"true","can_edit":"true"}', 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (49, 4, 18, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (50, 4, 7, null, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (51, 4, 8, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (52, 4, 9, null, 13, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (53, 4, 10, null, 14, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (62, 3, 6, '{"statistics_name":"miss_count.miss"}', 18, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (63, 5, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (64, 5, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (65, 5, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (66, 5, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (67, 5, 5, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (68, 5, 6, '{"statistics_name":"invalid_length_count.valids"}', 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (69, 5, 24, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (70, 5, 23, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (71, 5, 7, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (72, 5, 8, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (73, 5, 9, null, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (74, 5, 10, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (75, 5, 17, '', 13, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (76, 5, 19, null, 14, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (79, 6, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (80, 6, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (81, 6, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (82, 6, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (83, 6, 5, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (84, 6, 6, '{"statistics_name":"duplicate_count.duplicates"}', 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (85, 6, 7, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (86, 6, 8, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (87, 6, 9, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (88, 6, 10, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (89, 6, 17, '', 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (90, 6, 19, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (93, 7, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (94, 7, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (95, 7, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (96, 7, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (97, 7, 5, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (98, 7, 6, '{"statistics_name":"regexp_count.regexps"}', 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (99, 7, 25, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (100, 7, 7, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (101, 7, 8, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (102, 7, 9, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (103, 7, 10, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (104, 7, 17, null, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (105, 7, 19, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (108, 8, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (109, 8, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (110, 8, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (111, 8, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (112, 8, 5, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (113, 8, 6, '{"statistics_name":"timeliness_count.timeliness"}', 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (114, 8, 26, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (115, 8, 27, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (116, 8, 7, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (117, 8, 8, null, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (118, 8, 9, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (119, 8, 10, null, 13, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (120, 8, 17, null, 14, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (121, 8, 19, null, 15, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (124, 9, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (125, 9, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (126, 9, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (127, 9, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (128, 9, 5, null, 5, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (129, 9, 6, '{"statistics_name":"enum_count.enums"}', 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (130, 9, 28, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (131, 9, 7, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (132, 9, 8, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (133, 9, 9, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (134, 9, 10, null, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (135, 9, 17, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (136, 9, 19, null, 13, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (139, 10, 1, null, 1, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (140, 10, 2, null, 2, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (141, 10, 3, null, 3, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (142, 10, 4, null, 4, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (143, 10, 6, '{"statistics_name":"table_count.total"}', 6, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (144, 10, 7, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (145, 10, 8, null, 8, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (146, 10, 9, null, 9, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (147, 10, 10, null, 10, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (148, 10, 17, null, 11, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (149, 10, 19, null, 12, '2021-03-03 11:31:24', '2021-03-03 11:31:24');
INSERT INTO t_ds_relation_rule_input_entry (id, rule_id, rule_input_entry_id, values_map, `index`, create_time, update_time) VALUES (150, 8, 29, null, 7, '2021-03-03 11:31:24', '2021-03-03 11:31:24');


INSERT INTO t_ds_user (id, user_name, user_password, user_type, email, phone, tenant_id, create_time, update_time, queue, state, time_zone) VALUES (1, 'admin', '7ad2410b2f4c074479a8937a28a22b8f', 0, 'xxx@qq.com', '', 0, '2018-03-27 15:48:50', '2018-10-24 17:40:22', null, 1, null);

INSERT INTO t_ds_version (id, version) VALUES (1, '3.0.1');

--兼容mysql与pg系统表
create schema information_schema;
create view information_schema.TABLES as select * from user_tables;



