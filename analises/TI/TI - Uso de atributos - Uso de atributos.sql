select att.cdattribute, att.nmlabel
, (select distinct 'X' from adattribute where exists (select cdattribute from ADCOMPATTRIB where cdattribute = att.CDATTRIBUTE)) empresa
, (select distinct 'X' from adattribute where exists (select cdattribute from DCDOCUMENTATTRIB where cdattribute = att.CDATTRIBUTE)) attrib_documento
, (select distinct 'X' from adattribute where exists (select cdattribute from ADCOMPTYPEATTRIB where cdattribute = att.CDATTRIBUTE)) Tipo_empresa
, (select distinct 'X' from adattribute where exists (select cdattribute from DCCATDOCATTRIB where cdattribute = att.CDATTRIBUTE)) Atributo_categoria
, (select distinct 'X' from adattribute where exists (select cdattribute from DCCATEGORYATTRIB where cdattribute = att.CDATTRIBUTE)) Atributo_categoria_
, (select distinct 'X' from adattribute where exists (select cdattribute from GNACTIVITYATTPLAN where cdattribute = att.CDATTRIBUTE)) planejamento_atividade
, (select distinct 'X' from adattribute where exists (select cdattribute from GNACTIVITYATTRIB where cdattribute = att.CDATTRIBUTE)) atividade
, (select distinct 'X' from adattribute where exists (select cdattribute from GNGENTYPETTRIB where cdattribute = att.CDATTRIBUTE)) tipo_generico
, (select distinct 'X' from adattribute where exists (select cdattribute from GNHIERARCHYLEVEL where cdattribute = att.CDATTRIBUTE)) navegador_dinamico
, (select distinct 'X' from adattribute where exists (select cdattribute from GNMASKFIELD where cdattribute = att.CDATTRIBUTE)) Itens_mascara
, (select distinct 'X' from adattribute where exists (select cdattribute from GNREQUESTTYPEATR where cdattribute = att.CDATTRIBUTE)) tipo_solicit
, (select distinct 'X' from adattribute where exists (select cdattribute from PMACTATTRIB where cdattribute = att.CDATTRIBUTE)) processo
, (select distinct 'X' from adattribute where exists (select cdattribute from PMACTIONPARAMAPP where cdattribute = att.CDATTRIBUTE)) Aplic_externa
, (select distinct 'X' from adattribute where exists (select cdattribute from PMACTTYPEATTRIB where cdattribute = att.CDATTRIBUTE)) tipo_processo
, (select distinct 'X' from adattribute where exists (select cdattribute from PMATTRIBVALUEITEM where cdattribute = att.CDATTRIBUTE)) expressão_condicional
, (select distinct 'X' from adattribute where exists (select cdattribute from PMEXPITEM where cdattribute = att.CDATTRIBUTE)) expressão_condicional_
, (select distinct 'X' from adattribute where exists (select cdattribute from PMEXECMATRIXITEM where cdattribute = att.CDATTRIBUTE)) matriz_responsabilidade
, (select distinct 'X' from adattribute where exists (select cdattribute from PMEXECUTIONMATRIX where cdattribute = att.CDATTRIBUTE)) matrizes_responsabilidade_
, (select distinct 'X' from adattribute where exists (select cdattribute from PMPROCATTRIB where cdattribute = att.CDATTRIBUTE)) instância_processo
, (select distinct 'X' from adattribute where exists (select cdattribute from PMSTRUCT where cdattribute = att.CDATTRIBUTE)) estrutura_processo
, (select distinct 'X' from adattribute where exists (select cdattribute from PMSTRUCTATTRIB where cdattribute = att.CDATTRIBUTE)) atividade_processo
, (select distinct 'X' from adattribute where exists (select cdattribute from PMSTRUCTNOTIFYLIST where cdattribute = att.CDATTRIBUTE)) notific_atividades_processo
, (select distinct 'X' from adattribute where exists (select cdattribute from PMSTRUCTRETURNDATA where cdattribute = att.CDATTRIBUTE)) retorno_atividade_sistema
, (select distinct 'X' from adattribute where exists (select cdattribute from PMSTRUCTSENDDATA where cdattribute = att.CDATTRIBUTE)) envio_atividade_sistema
, 1 as qtd
from adattribute att
