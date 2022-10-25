<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gmd="http://standards.iso.org/iso/19115/-3/gmd"
                xmlns:gmx="http://standards.iso.org/iso/19115/-3/gmx"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:srv="http://standards.iso.org/iso/19115/-3/srv/2.0"
                xmlns:mdb="http://standards.iso.org/iso/19115/-3/mdb/2.0"
                xmlns:mcc="http://standards.iso.org/iso/19115/-3/mcc/1.0"
                xmlns:mri="http://standards.iso.org/iso/19115/-3/mri/1.0"
                xmlns:mrs="http://standards.iso.org/iso/19115/-3/mrs/1.0"
                xmlns:mrd="http://standards.iso.org/iso/19115/-3/mrd/1.0"
                xmlns:mco="http://standards.iso.org/iso/19115/-3/mco/1.0"
                xmlns:msr="http://standards.iso.org/iso/19115/-3/msr/2.0"
                xmlns:lan="http://standards.iso.org/iso/19115/-3/lan/1.0"
                xmlns:gcx="http://standards.iso.org/iso/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/iso/19115/-3/gex/1.0"
                xmlns:dqm="http://standards.iso.org/iso/19157/-2/dqm/1.0"
                xmlns:cit="http://standards.iso.org/iso/19115/-3/cit/2.0"
                xmlns:mdq="http://standards.iso.org/iso/19157/-2/mdq/1.0"
                xmlns:mrl="http://standards.iso.org/iso/19115/-3/mrl/2.0"
                xmlns:gco="http://standards.iso.org/iso/19115/-3/gco/1.0"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is
      the preferred method for meta-stylesheets to use where possible.
    -->
<xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <xsl:include xmlns:svrl="http://purl.oclc.org/dsdl/svrl" href="../../../xsl/utils-fn.xsl"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="lang"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="thesaurusDir"/>
   <xsl:param xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="rule"/>
   <xsl:variable xmlns:svrl="http://purl.oclc.org/dsdl/svrl" name="loc"
                 select="document(concat('../loc/', $lang, '/', $rule, '.xml'))"/>

   <!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators
    -->
<xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                      and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@
              <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans
      (Top-level element has index)
    -->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@
        <xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH-->
<xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2-->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters--><xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
<xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="INSPIRE rules"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>
         
        <xsl:value-of select="$archiveNameParameter"/>
         
        <xsl:value-of select="$fileNameParameter"/>
         
        <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.opengis.net/gml" prefix="gml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gmd" prefix="gmd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gmx" prefix="gmx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.fao.org/geonetwork" prefix="geonet"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2004/02/skos/core#" prefix="skos"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/srv/2.0" prefix="srv"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mdb/2.0" prefix="mdb"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mcc/1.0" prefix="mcc"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mri/1.0" prefix="mri"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrs/1.0" prefix="mrs"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrd/1.0" prefix="mrd"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mco/1.0" prefix="mco"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/msr/2.0" prefix="msr"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/lan/1.0" prefix="lan"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gcx/1.0" prefix="gcx"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gex/1.0" prefix="gex"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19157/-2/dqm/1.0" prefix="dqm"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/cit/2.0" prefix="cit"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19157/-2/mdq/1.0" prefix="mdq"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/mrl/2.0" prefix="mrl"/>
         <svrl:ns-prefix-in-attribute-values uri="http://standards.iso.org/iso/19115/-3/gco/1.0" prefix="gco"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.identification</xsl:attribute>
            <xsl:attribute name="name_en">Resource identification</xsl:attribute>
            <xsl:attribute name="name_fr">Identification de la ressource</xsl:attribute>
            <xsl:attribute name="name">Identification de la ressource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.dataIdentification</xsl:attribute>
            <xsl:attribute name="name_en">Data Identification</xsl:attribute>
            <xsl:attribute name="name_fr">Identification des données</xsl:attribute>
            <xsl:attribute name="name">Identification des données</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.serviceIdentification</xsl:attribute>
            <xsl:attribute name="name_en">Service Identification</xsl:attribute>
            <xsl:attribute name="name_fr">Identification des services</xsl:attribute>
            <xsl:attribute name="name">Identification des services</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.keyword</xsl:attribute>
            <xsl:attribute name="name_en">Keyword and INSPIRE themes</xsl:attribute>
            <xsl:attribute name="name_fr">Mots clés et thèmes INSPIRE</xsl:attribute>
            <xsl:attribute name="name">Mots clés et thèmes INSPIRE</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.serviceTaxonomy</xsl:attribute>
            <xsl:attribute name="name_en">INSPIRE Service taxonomy</xsl:attribute>
            <xsl:attribute name="name_fr">Catégorie de services</xsl:attribute>
            <xsl:attribute name="name">Catégorie de services</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.geographic.location</xsl:attribute>
            <xsl:attribute name="name_en">Geographic location</xsl:attribute>
            <xsl:attribute name="name_fr">Situation géographique</xsl:attribute>
            <xsl:attribute name="name">Situation géographique</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.temporal.reference</xsl:attribute>
            <xsl:attribute name="name_en">Temporal reference</xsl:attribute>
            <xsl:attribute name="name_fr">Référence temporelle</xsl:attribute>
            <xsl:attribute name="name">Référence temporelle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.quality</xsl:attribute>
            <xsl:attribute name="name_en">Quality and validity</xsl:attribute>
            <xsl:attribute name="name_fr">Qualité et validité</xsl:attribute>
            <xsl:attribute name="name">Qualité et validité</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.conformity</xsl:attribute>
            <xsl:attribute name="name_en">Conformity</xsl:attribute>
            <xsl:attribute name="name_fr">Conformité</xsl:attribute>
            <xsl:attribute name="name">Conformité</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.constraints</xsl:attribute>
            <xsl:attribute name="name_en">Constraints related to access and use</xsl:attribute>
            <xsl:attribute name="name_fr">Contrainte d'accès et d'utilisation</xsl:attribute>
            <xsl:attribute name="name">Contrainte d'accès et d'utilisation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.organisation</xsl:attribute>
            <xsl:attribute name="name_en">Responsible organisation</xsl:attribute>
            <xsl:attribute name="name_fr">Organisation responsable</xsl:attribute>
            <xsl:attribute name="name">Organisation responsable</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">rule.metadata</xsl:attribute>
            <xsl:attribute name="name_en">Metadata on metadata</xsl:attribute>
            <xsl:attribute name="name_fr">Métadonnées concernant les métadonnées</xsl:attribute>
            <xsl:attribute name="name">Métadonnées concernant les métadonnées</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">INSPIRE rules</svrl:text>

   <!--PATTERN
        rule.identificationResource identification Identification de la ressource-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Resource identification</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Identification de la ressource</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mdb:identificationInfo/*/mri:citation/cit:CI_Citation" priority="1003"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mdb:identificationInfo/*/mri:citation/cit:CI_Citation"/>
      <xsl:variable name="resourceTitle" select="cit:title/*/text()"/>
      <xsl:variable name="noResourceTitle"
                    select="not(cit:title) or cit:title/@gco:nilReason='missing'"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($noResourceTitle)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($noResourceTitle)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-cit-title-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource title is missing.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-cit-title-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
L'intitulé de la ressource est manquant.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($noResourceTitle)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($noResourceTitle)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-cit-title-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource title found:"<xsl:text/>
               <xsl:copy-of select="$resourceTitle"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-cit-title-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
L'intitulé de la ressource est :"<xsl:text/>
               <xsl:copy-of select="$resourceTitle"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"
                 priority="1002"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
      <xsl:variable name="resourceAbstract" select="mri:abstract/*/text()"/>
      <xsl:variable name="noResourceAbstract"
                    select="not(mri:abstract) or mri:abstract/@gco:nilReason='missing'"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($noResourceAbstract)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($noResourceAbstract)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-mri-abstract-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource abstract is missing.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-mri-abstract-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le résumé de la ressource est manquant.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($noResourceAbstract)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($noResourceAbstract)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-mri-abstract-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource abstract is :"<xsl:text/>
               <xsl:copy-of select="$resourceAbstract"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-mri-abstract-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le résumé de la ressource est :"<xsl:text/>
               <xsl:copy-of select="$resourceAbstract"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine/cit:CI_OnlineResource"
                 priority="1001"
                 mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mdb:distributionInfo/*/mrd:transferOptions/*/mrd:onLine/cit:CI_OnlineResource"/>
      <xsl:variable name="resourceLocator" select="cit:linkage/*/text()"/>
      <xsl:variable name="noResourceLocator"
                    select="normalize-space(cit:linkage/gco:CharacterString)=''       or not(cit:linkage)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($noResourceLocator)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($noResourceLocator)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-cit-CI_OnlineResource-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource locator is missing (INSPIRE - Resource locator is mandatory if linkage is available). Implementing instructions: &gt;Specify a valid URL to the resource. If no direct link to a resource is available, provide link to a contact point where more information about the resource is available. For a service, the Resource Locator might be one of the following: a link to the service capabilities document; a link to the service WSDL document (SOAP Binding); a link to a web page with further instructions; a link to a client application that directly accesses the service
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-cit-CI_OnlineResource-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le localisateur de la ressource est manquant</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($noResourceLocator)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($noResourceLocator)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-cit-CI_OnlineResource-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource locator found:"<xsl:text/>
               <xsl:copy-of select="$resourceLocator"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-cit-CI_OnlineResource-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le localisateur de la ressource est :"<xsl:text/>
               <xsl:copy-of select="$resourceLocator"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mdb:MD_Metadata" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//mdb:MD_Metadata"/>
      <xsl:variable name="resourceType_present"
                    select="mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue='dataset'     or mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue='series'     or mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue='service'"/>
      <xsl:variable name="resourceType"
                    select="string-join(mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue, ',')"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$resourceType_present"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$resourceType_present">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-mcc-MD_ScopeCode-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource type is missing or has a wrong value. Implementing instructions: The values of MD_ScopeCode in the scope of the directive (See SC4 in 1.2) are: dataset for spatial datasets;series for spatial dataset series;services for spatial data services. The hierarchyLevel property is not mandated by ISO 19115, but is mandated for conformance to the INSPIRE Metadata Implementing rules (See SC2 in 1.2). 
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.identification-mcc-MD_ScopeCode-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le type de la ressource est manquant ou sa valeur est incorrecte (valeurs autorisées : 'Série de données', 'Ensemble de séries de données' ou 'Service').</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$resourceType_present">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$resourceType_present">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-mcc-MD_ScopeCode-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource type is: "<xsl:text/>
               <xsl:copy-of select="$resourceType"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.identification-mcc-MD_ScopeCode-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le type de la ressource est :"<xsl:text/>
               <xsl:copy-of select="$resourceType"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN
        rule.dataIdentificationData Identification Identification des données-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Data Identification</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Identification des données</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification[    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '']|    //*[@gco:isoType='mri:MD_DataIdentification' and (    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_Metadatacope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '')]"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification[    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '']|    //*[@gco:isoType='mri:MD_DataIdentification' and (    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_Metadatacope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '')]"/>
      <xsl:variable name="resourceLanguage"
                    select="string-join(mri:defaultLocale/*/lan:language/gco:CharacterString|mri:defaultLocale/*/lan:language/lan:LanguageCode/@codeListValue, ', ')"/>
      <xsl:variable name="euLanguage"
                    select="not(mri:defaultLocale/*/lan:language/@gco:nilReason='missing') and contains(string-join(('eng', 'fre', 'ger', 'spa', 'dut', 'ita', 'cze', 'lav', 'dan', 'lit', 'mlt', 'pol', 'est', 'por', 'fin', 'rum', 'slo', 'slv', 'gre', 'bul', 'hun', 'swe', 'gle'), ', '), $resourceLanguage)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$euLanguage"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$euLanguage">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.dataIdentification-lan-language-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
INSPIRE (datasets and series) - Resource language is mandatory if the resource includes textual information. An instance of the language property is mandated by ISO19115 ; it can be defaulted to the value of the Metadata Implementing instructions Language when the dataset or the dataset series does not contain textual information. Implementing instructions: Codelist (See ISO/TS 19139) based on alpha-3 codes of ISO 639-2.
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.dataIdentification-lan-language-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
La langue de la ressource est manquante ou a une valeur incorrecte</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$euLanguage">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$euLanguage">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-lan-language-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Resource language is:"<xsl:text/>
               <xsl:copy-of select="$resourceLanguage"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-lan-language-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
La langue de la ressource est :"<xsl:text/>
               <xsl:copy-of select="$resourceLanguage"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="topic" select="mri:topicCategory/mri:MD_TopicCategoryCode"/>
      <xsl:variable name="noTopic"
                    select="not(mri:topicCategory)  or normalize-space(mri:topicCategory/mri:MD_TopicCategoryCode/text()) = ''"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($noTopic)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($noTopic)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.dataIdentification-mri-topicCategory-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
ISO topic category is missing (INSPIRE - ISO topic category is mandatory). The topic categories defined in Part D 2 of the INSPIRE Implementing rules for metadata are derived directly from the topic categories defined in B.5.27 of ISO 19115. INSPIRE Implementing rules for metadata define the INSPIRE data themes to which each topic category is Implementing instructions applicable, i.e., Administrative units (I.4) and Statistical units (III.1) are INSPIRE themes for which the boundaries topic category is applicable. The value of the ISO 19115/ISO 19119 metadata element is the value appearing in the “name” column of the table in B.5.27 of ISO 19115.
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.dataIdentification-mri-topicCategory-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Une catégorie thématique est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($noTopic)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($noTopic)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-mri-topicCategory-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
ISO topic category is:"<xsl:text/>
               <xsl:copy-of select="$topic"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-mri-topicCategory-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
La catégorie thématique est :"<xsl:text/>
               <xsl:copy-of select="$topic"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="resourceIdentifier"
                    select="mri:citation/cit:CI_Citation/cit:identifier      and not(mri:citation/cit:CI_Citation/cit:identifier[*/mcc:code/@gco:nilReason='missing'])"/>
      <xsl:variable name="resourceIdentifier_code"
                    select="mri:citation/cit:CI_Citation/cit:identifier/*/mcc:code/*/text()"/>
      <xsl:variable name="resourceIdentifier_codeSpace"
                    select="mri:citation/cit:CI_Citation/cit:identifier/*/mcc:codeSpace/*/text()"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$resourceIdentifier"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$resourceIdentifier">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.dataIdentification-cit-identifier-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Unique resource identifier is missing. Mandatory for dataset and dataset series. Example: 527c4cac-070c-4bca-9aaf-92bece7be902
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.dataIdentification-cit-identifier-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
L'identificateur de ressource unique est manquant.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$resourceIdentifier_code">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$resourceIdentifier_code">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-cit-identifier-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Unique resource identifier is:"<xsl:text/>
               <xsl:copy-of select="$resourceIdentifier_code"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-cit-identifier-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
L'identificateur de ressource unique est :"<xsl:text/>
               <xsl:copy-of select="$resourceIdentifier_code"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$resourceIdentifier_codeSpace">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$resourceIdentifier_codeSpace">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-cit-identifier-codespace-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Unique resource identifier codespace is:"<xsl:text/>
               <xsl:copy-of select="$resourceIdentifier_codeSpace"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.dataIdentification-cit-identifier-codespace-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
L'espace de nom de l'identificateur de ressource unique est :"<xsl:text/>
               <xsl:copy-of select="$resourceIdentifier_codeSpace"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN
        rule.serviceIdentificationService Identification Identification des services-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Service Identification</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Identification des services</svrl:text>

  <!--RULE
      -->
<xsl:template match="//srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
      <xsl:variable name="coupledResourceHref"
                    select="string-join(srv:operatesOn/@xlink:href, ', ')"/>
      <xsl:variable name="coupledResourceUUID" select="string-join(srv:operatesOn/@uuidref, ', ')"/>
      <xsl:variable name="coupledResource"
                    select="../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue='service'     and //srv:operatesOn"/>

      <!--REPORT
      -->
<xsl:if test="$coupledResource and $coupledResourceHref!=''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$coupledResource and $coupledResourceHref!=''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceIdentification-srv-operatesOn-coupledResourceHref-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Coupled resources found : "<xsl:text/>
               <xsl:copy-of select="$coupledResourceHref"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceIdentification-srv-operatesOn-coupledResourceHref-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Les ressources couplées sont : "<xsl:text/>
               <xsl:copy-of select="$coupledResourceHref"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$coupledResource and $coupledResourceUUID!=''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$coupledResource and $coupledResourceUUID!=''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceIdentification-srv-operatesOn-coupledResourceUUID-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
ReCoupled resources found : "<xsl:text/>
               <xsl:copy-of select="$coupledResourceUUID"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceIdentification-srv-operatesOn-coupledResourceUUID-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Les ressources couplées sont : "<xsl:text/>
               <xsl:copy-of select="$coupledResourceUUID"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="serviceType" select="srv:serviceType/gco:LocalName"/>
      <xsl:variable name="noServiceType"
                    select="contains(string-join(('view', 'discovery', 'download', 'transformation', 'invoke', 'other'), ','), srv:serviceType/gco:LocalName)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$noServiceType"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$noServiceType">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.serviceIdentification-srv-serviceType-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
ServiceType is missing. Mandatory for services. Not applicable to dataset and dataset series. Example: 'view', 'discovery', 'download', 'transformation', 'invoke', 'other'.
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.serviceIdentification-srv-serviceType-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le type de service est manquant ou sa valeur est incorrecte (valeurs autorisées : 'view', 'discovery', 'download', 'transformation', 'invoke', 'other').</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$noServiceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$noServiceType">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceIdentification-srv-serviceType-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Service type is : "<xsl:text/>
               <xsl:copy-of select="$serviceType"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceIdentification-srv-serviceType-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le type de service est :"<xsl:text/>
               <xsl:copy-of select="$serviceType"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN
        rule.keywordKeyword and INSPIRE themes Mots clés et thèmes INSPIRE-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Keyword and INSPIRE themes</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Mots clés et thèmes INSPIRE</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']"/>
      <xsl:variable name="inspire-thesaurus"
                    select="document(concat($thesaurusDir, '/external/thesauri/theme/httpinspireeceuropaeutheme-theme.rdf'))"/>
      <xsl:variable name="inspire-theme" select="$inspire-thesaurus//skos:Concept"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count($inspire-theme) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count($inspire-theme) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.keyword-thesaurus-file-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
INSPIRE Theme thesaurus not found. Download thesaurus from the INSPIRE Registry.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.keyword-thesaurus-file-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le thesaurus du thème ISNPIRE n'a pas été trouvé. Télécharger le Registre INSPIRE.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="thesaurus_name"
                    select="mri:descriptiveKeywords/*/mri:thesaurusName/*/cit:title/*/text()"/>
      <xsl:variable name="thesaurus_date"
                    select="mri:descriptiveKeywords/*/mri:thesaurusName/*/cit:date/*/cit:date/*/text()"/>
      <xsl:variable name="thesaurus_dateType"
                    select="mri:descriptiveKeywords/*/mri:thesaurusName/*/cit:date/*/cit:dateType/*/@codeListValue/text()"/>
      <xsl:variable name="keyword"
                    select="mri:descriptiveKeywords/*/mri:keyword/gco:CharacterString|     mri:descriptiveKeywords/*/mri:keyword/gcx:Anchor"/>
      <xsl:variable name="inspire-theme-found"
                    select="count($inspire-thesaurus//skos:Concept[skos:prefLabel = $keyword])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$inspire-theme-found &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$inspire-theme-found &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.keyword-inspire-theme-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
INSPIRE theme is mandatory.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.keyword-inspire-theme-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le thème INSPIRE est manquant (mot clé issu du thésaurus "GEMET INSPIRE themes")</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$inspire-theme-found &gt; 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$inspire-theme-found &gt; 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.keyword-inspire-theme-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
"<xsl:text/>
               <xsl:copy-of select="$inspire-theme-found"/>
               <xsl:text/>" INSPIRE theme(s) found.</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.keyword-inspire-theme-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
"<xsl:text/>
               <xsl:copy-of select="$inspire-theme-found"/>
               <xsl:text/>" Thème INSPIRE trouvé.</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$thesaurus_name">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$thesaurus_name">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.keyword-thesaurus-name-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Thesaurus: "<xsl:text/>
               <xsl:copy-of select="$thesaurus_name"/>
               <xsl:text/>, <xsl:text/>
               <xsl:copy-of select="$thesaurus_date"/>
               <xsl:text/> (<xsl:text/>
               <xsl:copy-of select="$thesaurus_dateType"/>
               <xsl:text/>)"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.keyword-thesaurus-name-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Thesaurus: "<xsl:text/>
               <xsl:copy-of select="$thesaurus_name"/>
               <xsl:text/>, <xsl:text/>
               <xsl:copy-of select="$thesaurus_date"/>
               <xsl:text/> (<xsl:text/>
               <xsl:copy-of select="$thesaurus_dateType"/>
               <xsl:text/>)"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN
        rule.serviceTaxonomyINSPIRE Service taxonomy Catégorie de services-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">INSPIRE Service taxonomy</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Catégorie de services</svrl:text>

  <!--RULE
      -->
<xsl:template match="//srv:SV_ServiceIdentification|//*[@gco:isoType='srv:SV_ServiceIdentification']"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//srv:SV_ServiceIdentification|//*[@gco:isoType='srv:SV_ServiceIdentification']"/>
      <xsl:variable name="inspire-thesaurus"
                    select="document(concat($thesaurusDir, '/external/thesauri/theme/inspire-service-taxonomy.rdf'))"/>
      <xsl:variable name="inspire-st" select="$inspire-thesaurus//skos:Concept"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count($inspire-st) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count($inspire-st) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.serviceTaxonomy-taxonomy-file-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
INSPIRE service taxonomy thesaurus not found. Check installation in codelist/external/thesauri/theme. Download thesaurus from https://geonetwork.svn.sourceforge.net/svnroot/geonetwork/utilities/gemet/thesauri/.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.serviceTaxonomy-taxonomy-file-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le thesaurus de taxonomie des services ISNPIRE n'a pas été trouvé. Vérifier si ce dernier est bien installer (codelist/external/thesauri/theme). Télécharger le thesaurus à partir de l'url suivant https://geonetwork.svn.sourceforge.net/svnroot/geonetwork/utilities/gemet/thesauri/.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="keyword"
                    select="mri:descriptiveKeywords/*/gmd:keyword/gco:CharacterString|                 mri:descriptiveKeywords/*/gmd:keyword/gmx:Anchor"/>
      <xsl:variable name="inspire-theme-found"
                    select="count($inspire-thesaurus//skos:Concept[skos:prefLabel = $keyword])"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$inspire-theme-found &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$inspire-theme-found &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.serviceTaxonomy-inspire-theme-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Missing service taxonomy information (select on or more keyword from "inspire-service-taxonomy.rdf" thesaurus)</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.serviceTaxonomy-inspire-theme-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Une catégorie de service est manquante (mot clé issu du thesaurus "inspire-service-taxonomy")</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$inspire-theme-found &gt; 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$inspire-theme-found &gt; 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceTaxonomy-inspire-theme-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
A service taxonomy classification defined : "<xsl:text/>
               <xsl:copy-of select="$inspire-theme-found"/>
               <xsl:text/>"  </svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.serviceTaxonomy-inspire-theme-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Une catégorie de service est définie : "<xsl:text/>
               <xsl:copy-of select="$inspire-theme-found"/>
               <xsl:text/>" </svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN
        rule.geographic.locationGeographic location Situation géographique-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Geographic location</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Situation géographique</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification[    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '']    /mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox    |    //*[@gco:isoType='mri:MD_DataIdentification' and (    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '')]    /mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox    "
                 priority="1001"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification[    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '']    /mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox    |    //*[@gco:isoType='mri:MD_DataIdentification' and (    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'series'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'dataset'    or ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = '')]    /mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox    "/>
      <xsl:variable name="west" select="number(gex:westBoundLongitude/gco:Decimal/text())"/>
      <xsl:variable name="east" select="number(gex:eastBoundLongitude/gco:Decimal/text())"/>
      <xsl:variable name="north" select="number(gex:northBoundLatitude/gco:Decimal/text())"/>
      <xsl:variable name="south" select="number(gex:southBoundLatitude/gco:Decimal/text())"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-W-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
WestBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-W-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne ouest manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-W-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
WestBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$west"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-W-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne ouest :"<xsl:text/>
               <xsl:copy-of select="$west"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-E-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
EastBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-E-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne est manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-E-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
EastBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$east"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-E-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne est :"<xsl:text/>
               <xsl:copy-of select="$east"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(-90.00 &lt;= $south) and ($south &lt;= $north)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-S-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
SouthBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-S-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne sud manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-S-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
SouthBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$south"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-S-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne sud :"<xsl:text/>
               <xsl:copy-of select="$south"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="($south &lt;= $north) and ($north &lt;= 90.00)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="($south &lt;= $north) and ($north &lt;= 90.00)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-N-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
NorthBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-mri-MD_DataIdentification-N-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne nord manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="($south &lt;= $north) and ($north &lt;= 90.00)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="($south &lt;= $north) and ($north &lt;= 90.00)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-N-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
NorthBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$north"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-mri-MD_DataIdentification-N-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne nord :"<xsl:text/>
               <xsl:copy-of select="$north"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//srv:SV_ServiceIdentification[    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'service']    /mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//srv:SV_ServiceIdentification[    ../../mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue/normalize-space(.) = 'service']    /mri:extent/gex:EX_Extent/gex:geographicElement/gex:EX_GeographicBoundingBox"/>
      <xsl:variable name="west" select="number(gex:westBoundLongitude/gco:Decimal/text())"/>
      <xsl:variable name="east" select="number(gex:eastBoundLongitude/gco:Decimal/text())"/>
      <xsl:variable name="north" select="number(gex:northBoundLatitude/gco:Decimal/text())"/>
      <xsl:variable name="south" select="number(gex:southBoundLatitude/gco:Decimal/text())"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-W-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
WestBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-W-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne ouest manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="(-180.00 &lt;= $west) and ( $west &lt;= 180.00)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-W-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
WestBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$west"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-W-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne ouest :"<xsl:text/>
               <xsl:copy-of select="$west"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-E-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
EastBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-E-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne est manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="(-180.00 &lt;= $east) and ($east &lt;= 180.00)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-E-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
EastBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$east"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-E-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne est :"<xsl:text/>
               <xsl:copy-of select="$east"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="(-90.00 &lt;= $south) and ($south &lt;= $north)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-S-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
SouthBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-S-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne sud manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="(-90.00 &lt;= $south) and ($south &lt;= $north)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-S-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
SouthBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$south"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-S-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne sud :"<xsl:text/>
               <xsl:copy-of select="$south"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="($south &lt;= $north) and ($north &lt;= 90.00)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="($south &lt;= $north) and ($north &lt;= 90.00)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-N-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
NorthBoundLongitude is missing or has wrong value.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.geographic.location-SV-ServiceIdentification-N-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne nord manquante ou valeur invalide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="($south &lt;= $north) and ($north &lt;= 90.00)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="($south &lt;= $north) and ($north &lt;= 90.00)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-N-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
NorthBoundLongitude found:"<xsl:text/>
               <xsl:copy-of select="$north"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.geographic.location-SV-ServiceIdentification-N-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Borne nord :"<xsl:text/>
               <xsl:copy-of select="$north"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN
        rule.temporal.referenceTemporal reference Référence temporelle-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Temporal reference</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Référence temporelle</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>
      <xsl:variable name="temporalExtentBegin"
                    select="mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:beginPosition/text()"/>
      <xsl:variable name="temporalExtentEnd"
                    select="mri:extent/*/gex:temporalElement/*/gex:extent/*/gml:endPosition/text()"/>
      <xsl:variable name="publicationDate"
                    select="mri:citation/*/cit:date[./*/cit:dateType/*/@codeListValue='publication']/*/cit:date/*"/>
      <xsl:variable name="creationDate"
                    select="mri:citation/*/cit:date[./*/cit:dateType/*/@codeListValue='creation']/*/cit:date/*"/>
      <xsl:variable name="no_creationDate"
                    select="count(mri:citation/*/cit:date[./*/cit:dateType/*/@codeListValue='creation'])"/>
      <xsl:variable name="revisionDate"
                    select="mri:citation/*/cit:date[./*/cit:dateType/*/@codeListValue='revision']/*/cit:date/*"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$no_creationDate &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$no_creationDate &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.temporal.reference-temporaldate-creation-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
There shall not be more than one instance of MD_Metadata.identificationInfo[1].MD_Identification.citation.CI_Citation.date declared as a creation date (i.e. CI_Date.dateType having the creation value).</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.temporal.reference-temporaldate-creation-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Il ne peut y avoir plus d'une date de création
        (i.e. CI_Date.dateType ayant la valeur creation).</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$publicationDate or $creationDate or $revisionDate or $temporalExtentBegin or $temporalExtentEnd"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$publicationDate or $creationDate or $revisionDate or $temporalExtentBegin or $temporalExtentEnd">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.temporal.reference-temporaldate-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Temporal reference is missing (INSPIRE - Temporal reference is mandatory). No instance of Temporal reference has been found. Implementing instructions: Each instance of the temporal extent may be an interval  of dates or an individual date. The overall time period covered by the content of the resource may be composed of one or many instances. Or a reference date of the cited resource (publication, last revision or creation). Example: From 1977-03-10T11:45:30 to 2005-01-15T09:10:00
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.temporal.reference-temporaldate-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Une référence temporelle est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$temporalExtentBegin">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$temporalExtentBegin">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-begin-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Temporal extent (begin) found:"<xsl:text/>
               <xsl:copy-of select="$temporalExtentBegin"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-begin-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Etendue temporelle (début) trouvée :"<xsl:text/>
               <xsl:copy-of select="$temporalExtentBegin"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$temporalExtentEnd">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$temporalExtentEnd">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-end-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Temporal extent (end) found : "<xsl:text/>
               <xsl:copy-of select="$temporalExtentEnd"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-end-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Etendue temporelle (fin) trouvée :"<xsl:text/>
               <xsl:copy-of select="$temporalExtentEnd"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$publicationDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$publicationDate">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-publication-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Date of publication of the resource found :"<xsl:text/>
               <xsl:copy-of select="$publicationDate"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-publication-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Date de publication de la ressource :"<xsl:text/>
               <xsl:copy-of select="$publicationDate"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$revisionDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$revisionDate">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-revision-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Date of revision of the resource found :"<xsl:text/>
               <xsl:copy-of select="$revisionDate"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-revision-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Date de révision de la ressource :"<xsl:text/>
               <xsl:copy-of select="$revisionDate"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$creationDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$creationDate">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-creation-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Date of creation of the resource found :"<xsl:text/>
               <xsl:copy-of select="$creationDate"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.temporal.reference-temporaldate-creation-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Date de création de la ressource :"<xsl:text/>
               <xsl:copy-of select="$creationDate"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN
        rule.qualityQuality and validity Qualité et validité-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Quality and validity</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Qualité et validité</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mdb:resourceLineage" priority="1001" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//mdb:resourceLineage"/>
      <xsl:variable name="lineage"
                    select="not(mrl:LI_Lineage/mrl:statement) or (mrl:LI_lineage/mrl:statement/@gco:nilReason)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($lineage)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($lineage)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.quality-lineage-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Lineage is missing (INSPIRE - Lineage is mandatory). Mandatory for spatial dataset and spatial dataset series; not applicable to services. In addition to general explanation of the data producer’s knowledge about the lineage of a dataset it is possible to put data quality statements here. A single ISO 19115 metadata set may comprise more than one set of Implementing instructions   quality information, each of them having one or zero lineage statement. There shall be one and only one set of quality information scoped to the full resource and having a lineage statement (See SC6 in 1.2). Example: Dataset has been digitised from the standard 1:5.000 map
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.quality-lineage-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
La généalogie de la ressource est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($lineage)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($lineage)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.quality-lineage-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Lineage is set.</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.quality-lineage-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
La généalogie de la ressource est définie.</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification/mri:spatialResolution|//*[@gco:isoType='mri:MD_DataIdentification']/mri:spatialResolution"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification/mri:spatialResolution|//*[@gco:isoType='mri:MD_DataIdentification']/mri:spatialResolution"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="*/mri:equivalentScale or */mri:distance or */mri:vertical or */mri:angularDistance or */mri:levelOfDetail"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="*/mri:equivalentScale or */mri:distance or */mri:vertical or */mri:angularDistance or */mri:levelOfDetail">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.quality-mri-spatialResolution-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
 Spatial resolution is missing (INSPIRE - Spatial resolution is mandatory if an equivalent scale or a resolution distance can be specified). Implementing instructions: Each spatial resolution is either an equivalent scale OR a ground sample distance. When two equivalent scales or two ground sample distances are expressed, the spatial resolution is an interval bounded by these two values. Example: 5000 (e.g. 1:5000 scale map)
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.quality-mri-spatialResolution-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
La résolution spatiale est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="*/mri:equivalentScale or */mri:distance or */mri:vertical or */mri:angularDistance or */mri:levelOfDetail">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="*/mri:equivalentScale or */mri:distance or */mri:vertical or */mri:angularDistance or */mri:levelOfDetail">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.quality-mri-spatialResolution-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Spatial resolution is set.</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.quality-mri-spatialResolution-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
La résolution spatiale est définie.</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN
        rule.conformityConformity Conformité-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Conformity</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Conformité</svrl:text>

  <!--RULE
      -->
<xsl:template match="/mdb:MD_Metadata" priority="1001" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/mdb:MD_Metadata"/>
      <xsl:variable name="degree"
                    select="count(mdb:dataQualityInfo/*/mdq:report/*/mdq:result/*/mdq:pass)"/>

      <!--REPORT
      -->
<xsl:if test="$degree = 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$degree = 0">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.conformity-degree-nonev-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
The degree of conformity of the resource has not yet been evaluated.</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.conformity-degree-nonev-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le degré de conformité de la ressource n'a pas encore été évalué</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mdb:dataQualityInfo/*/mdq:report/*/mdq:result/*" priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mdb:dataQualityInfo/*/mdq:report/*/mdq:result/*"/>
      <xsl:variable name="degree" select="mdq:pass/*/text()"/>
      <xsl:variable name="specification_title" select="mdq:specification/*/cit:title/*/text()"/>
      <xsl:variable name="specification_date"
                    select="mdq:specification/*/cit:date/*/cit:date/*/text()"/>
      <xsl:variable name="specification_dateType"
                    select="normalize-space(mdq:specification/*/cit:date/*/cit:dateType/*/@codeListValue)"/>

      <!--REPORT
      -->
<xsl:if test="$specification_title">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$specification_title">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.conformity-specification-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Spécification :"<xsl:text/>
               <xsl:copy-of select="$specification_title"/>
               <xsl:text/>" , "<xsl:text/>
               <xsl:copy-of select="$specification_date"/>
               <xsl:text/>", "<xsl:text/>
               <xsl:copy-of select="$specification_dateType"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.conformity-specification-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Spécification :"<xsl:text/>
               <xsl:copy-of select="$specification_title"/>
               <xsl:text/>" , "<xsl:text/>
               <xsl:copy-of select="$specification_date"/>
               <xsl:text/>", "<xsl:text/>
               <xsl:copy-of select="$specification_dateType"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$degree">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$degree">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.conformity-degree-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Degree of conformity found:"<xsl:text/>
               <xsl:copy-of select="$degree"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.conformity-degree-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Degré de conformité :"<xsl:text/>
               <xsl:copy-of select="$degree"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN
        rule.constraintsConstraints related to access and use Contrainte d'accès et d'utilisation-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Constraints related to access and use</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Contrainte d'accès et d'utilisation</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"
                 priority="1001"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification|    //*[@gco:isoType='mri:MD_DataIdentification']|    //srv:SV_ServiceIdentification|    //*[@gco:isoType='srv:SV_ServiceIdentification']"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="count(mri:resourceConstraints/*) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="count(mri:resourceConstraints/*) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-mri-resourceConstraints-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
There shall be at least one instance of
        MD_Metadata.identificationInfo[1].MD_Identification.resourceConstraints</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-mri-resourceConstraints-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Une contrainte sur la ressource est requise (voir
        MD_Metadata.identificationInfo[1].MD_Identification.resourceConstraints)</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="accessConstraints_count"
                    select="count(mri:resourceConstraints/*/mco:accessConstraints[*/@codeListValue != ''])"/>
      <xsl:variable name="accessConstraints_found" select="$accessConstraints_count &gt; 0"/>
      <xsl:variable name="accessConstraints"
                    select="     count(mri:resourceConstraints/*/mco:accessConstraints/mco:MD_RestrictionCode[@codeListValue='otherRestrictions'])&gt;0      and (     not(mri:resourceConstraints/*/mco:otherConstraints)          or mri:resourceConstraints/*/mco:otherConstraints[@gco:nilReason='missing']     )"/>
      <xsl:variable name="otherConstraints"
                    select="     mri:resourceConstraints/*/mco:otherConstraints and     mri:resourceConstraints/*/mco:otherConstraints/gco:CharacterString!='' and      count(mri:resourceConstraints/*/mco:accessConstraints/mco:MD_RestrictionCode[@codeListValue='otherRestrictions'])=0     "/>
      <xsl:variable name="otherConstraintInfo"
                    select="mri:resourceConstraints/*/mco:otherConstraints/gco:CharacterString"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$accessConstraints_found"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$accessConstraints_found">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-mco-accessConstraints-found-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
There shall be at least one instance of 'accessConstraints'</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-mco-accessConstraints-found-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Il doit y avoir au moins une valeur de contrainte d'accès.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$accessConstraints_found">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$accessConstraints_found">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-mco-accessConstraints-found-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
               <xsl:text/>
               <xsl:copy-of select="$accessConstraints_count"/>
               <xsl:text/> instance(s) of 'accessConstraints' found.</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-mco-accessConstraints-found-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
               <xsl:text/>
               <xsl:copy-of select="$accessConstraints_count"/>
               <xsl:text/> contrainte d'accès définie (accessConstraints).</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($accessConstraints)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($accessConstraints)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-allConstraints-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
The value of 'accessConstraints' must be 'otherRestrictions', 
    	if there are instances of 'otherConstraints' expressing limitations on public access. Check access constraints list and other constraints text field.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-allConstraints-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Les contraintes d'accès prennent la valeur 'autres restrictions' si 
        et seulement si une valeur de restrictions d'accès public au sens INSPIRE est renseignée.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($otherConstraints)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($otherConstraints)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-allConstraints-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
The value of 'accessConstraints' must be 'otherRestrictions', 
    	if there are instances of 'otherConstraints' expressing limitations on public access. Check access constraints list and other constraints text field.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-allConstraints-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Les contraintes d'accès prennent la valeur 'autres restrictions' si 
        et seulement si une valeur de restrictions d'accès public au sens INSPIRE est renseignée.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$otherConstraintInfo!='' and not($accessConstraints) and not($otherConstraints)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$otherConstraintInfo!='' and not($accessConstraints) and not($otherConstraints)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-allConstraints-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Limitation on public access (otherConstraints) found:"<xsl:text/>
               <xsl:copy-of select="$otherConstraintInfo"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-allConstraints-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Restrictions d'accès public au sens INSPIRE définie :"<xsl:text/>
               <xsl:copy-of select="$otherConstraintInfo"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mri:MD_DataIdentification/mri:resourceConstraints/*|    //*[@gco:isoType='mri:MD_DataIdentification']/mri:resourceConstraints/*|    //srv:SV_ServiceIdentification/mri:resourceConstraints/*|    //*[@gco:isoType='srv:SV_ServiceIdentification']/mri:resourceConstraints/*"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mri:MD_DataIdentification/mri:resourceConstraints/*|    //*[@gco:isoType='mri:MD_DataIdentification']/mri:resourceConstraints/*|    //srv:SV_ServiceIdentification/mri:resourceConstraints/*|    //*[@gco:isoType='srv:SV_ServiceIdentification']/mri:resourceConstraints/*"/>
      <xsl:variable name="accessConstraints"
                    select="string-join(mco:accessConstraints/*/@codeListValue, ', ')"/>
      <xsl:variable name="classification"
                    select="string-join(mco:classification/*/@codeListValue, ', ')"/>
      <xsl:variable name="otherConstraints"
                    select="mco:otherConstraints/gco:CharacterString/text()"/>
      <xsl:variable name="useLimitation" select="mco:useLimitation/*/text()"/>
      <xsl:variable name="useLimitation_count" select="count(mco:useLimitation/*/text())"/>

      <!--REPORT
      -->
<xsl:if test="$accessConstraints!=''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$accessConstraints!=''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-mco-accessConstraints-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Limitation on public access (accessConstraints) found:"<xsl:text/>
               <xsl:copy-of select="$accessConstraints"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-mco-accessConstraints-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Contrainte d'accès définie (accessConstraints) :"<xsl:text/>
               <xsl:copy-of select="$accessConstraints"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--REPORT
      -->
<xsl:if test="$classification!=''">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$classification!=''">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-classification-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Limitation on public access (classification) found:"<xsl:text/>
               <xsl:copy-of select="$classification"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-classification-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Contrainte de sécurité définie (classification) :"<xsl:text/>
               <xsl:copy-of select="$classification"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$useLimitation_count"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$useLimitation_count">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-useLimitation-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Conditions applying to access and use is missing.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.constraints-useLimitation-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Une condition applicable à l'accès et à l'utilisation de la ressource est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$useLimitation_count">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$useLimitation_count">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-useLimitation-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Conditions applying to access and use found :"<xsl:text/>
               <xsl:copy-of select="$useLimitation"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.constraints-useLimitation-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Condition applicable à l'accès et à l'utilisation de la ressource :"<xsl:text/>
               <xsl:copy-of select="$useLimitation"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN
        rule.organisationResponsible organisation Organisation responsable-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Responsible organisation</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Organisation responsable</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mdb:identificationInfo" priority="1001" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//mdb:identificationInfo"/>
      <xsl:variable name="missing" select="not(*/mri:pointOfContact)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($missing)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($missing)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.organisation-mri-pointOfContact-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Responsible organisation for the resource is missing (INSPIRE - Responsible organisation for the resource is mandatory). Relative to a responsible organisation, but there may be many responsible organisations for a single resource. Organisation name and email are required. See identification section / point of contact.
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.organisation-mri-pointOfContact-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Une organisation responsable de la ressource est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($missing)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($missing)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.organisation-mri-pointOfContact-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Responsible organisation for the resource found.</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.organisation-mri-pointOfContact-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Organisation responsable de la ressource trouvée.</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mdb:identificationInfo/*/mri:pointOfContact    |//*[@gco:isoType='mri:MD_DataIdentification']/mri:pointOfContact    |//*[@gco:isoType='srv:SV_ServiceIdentification']/mri:pointOfContact"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mdb:identificationInfo/*/mri:pointOfContact    |//*[@gco:isoType='mri:MD_DataIdentification']/mri:pointOfContact    |//*[@gco:isoType='srv:SV_ServiceIdentification']/mri:pointOfContact"/>
      <xsl:variable name="missing"
                    select="not(*/cit:party/*/cit:name)      or (*/cit:party/*/cit:name/@gco:nilReason)      or not(*/cit:party/*/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress)      or (*/cit:party/*/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress/@gco:nilReason)"/>
      <xsl:variable name="organisationName" select="*/cit:party/*/cit:name/*/text()"/>
      <xsl:variable name="role" select="*/cit:party/*/cit:individual/*/cit:positionName/*/text()"/>
      <xsl:variable name="emptyRole" select="$role=''"/>
      <xsl:variable name="name" select="*/cit:party/*/cit:individual/*/cit:name/*/text()"/>
      <xsl:variable name="emptyName" select="$name=''"/>
      <xsl:variable name="emailAddress"
                    select="*/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress/*/text()"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($missing)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($missing)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.organisation-info-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Organisation name and email not found for responsible organisation.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.organisation-info-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le nom et l'email de l'organisation responsable de la ressource sont manquants.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($emptyRole)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($emptyRole)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.organisation-cit-role-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Contact role is empty.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.organisation-cit-role-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le rôle de la partie responsable est vide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($emptyName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($emptyName)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.organisation-cit-name-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Contact name (responsible person) is empty.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.organisation-cit-name-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le nom de la personne responsable est vide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($missing)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($missing)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.organisation-info-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Organisation name and email found for :"<xsl:text/>
               <xsl:copy-of select="$organisationName"/>
               <xsl:text/>" ("<xsl:text/>
               <xsl:copy-of select="$role"/>
               <xsl:text/>")</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.organisation-info-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le nom et l'email de l'organisation responsable de la ressource sont définis pour :"<xsl:text/>
               <xsl:copy-of select="$organisationName"/>
               <xsl:text/>" ("<xsl:text/>
               <xsl:copy-of select="$role"/>
               <xsl:text/>")</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN
        rule.metadataMetadata on metadata Métadonnées concernant les métadonnées-->
<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Metadata on metadata</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Métadonnées concernant les métadonnées</svrl:text>

  <!--RULE
      -->
<xsl:template match="//mdb:MD_Metadata" priority="1001" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//mdb:MD_Metadata"/>
      <xsl:variable name="dateInfo" select="mdb:dateInfo/*/cit:date/*/text()"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$dateInfo"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$dateInfo">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.metadata-mdb-dateInfo-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Metadata date stamp is missing.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.metadata-mdb-dateInfo-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
La date des métadonnées est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$dateInfo">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$dateInfo">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.metadata-mdb-dateInfo-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Metadata date stamp is :"<xsl:text/>
               <xsl:copy-of select="$dateInfo"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.metadata-mdb-dateInfo-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
La date des métadonnées est :"<xsl:text/>
               <xsl:copy-of select="$dateInfo"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="language"
                    select="normalize-space(mdb:defaultLocale/*/lan:language/gco:CharacterString|mdb:defaultLocale/*/lan:language/lan:LanguageCode/@codeListValue)"/>
      <xsl:variable name="language_present"
                    select="contains(string-join(('eng', 'fre', 'ger', 'spa', 'dut', 'ita', 'cze', 'lav', 'dan', 'lit', 'mlt', 'pol', 'est', 'por', 'fin', 'rum', 'slo', 'slv', 'gre', 'bul', 'hun', 'swe', 'gle'), ','), $language)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="$language_present"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="$language_present">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.metadata-cit-LanguageCode-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Metadata language is missing (INSPIRE - Metadata language is mandatory). The language property is not mandated by ISO 19115, but is mandated for conformance to the INSPIRE Metadata Implementing rules.
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                          diagnostic="rule.metadata-cit-LanguageCode-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
La langue des métadonnées est manquante.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="$language_present">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="$language_present">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.metadata-cit-LanguageCode-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Metadata language is :"<xsl:text/>
               <xsl:copy-of select="$language"/>
               <xsl:text/>"</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}"
                                       diagnostic="rule.metadata-cit-LanguageCode-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
La langue des métadonnées est :"<xsl:text/>
               <xsl:copy-of select="$language"/>
               <xsl:text/>"</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="missing" select="not(mdb:contact)"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($missing)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($missing)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-mdb-contact-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Metadata point of contact is missing (INSPIRE - Metadata point of contact is mandatory). Implementing instructions: The role of the responsible party serving as a metadata point of contact is out of scope of the INSPIRE Implementing Rules, but this property is mandated by ISO 19115. Its value can be defaulted to pointOfContact.
		</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-mdb-contact-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le point de contact des métadonnées est manquant.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($missing)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($missing)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-mdb-contact-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Metadata point of contact found.</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-mdb-contact-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Point de contact des métadonnées trouvé</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

  <!--RULE
      -->
<xsl:template match="//mdb:MD_Metadata/mdb:contact" priority="1000" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//mdb:MD_Metadata/mdb:contact"/>
      <xsl:variable name="missing"
                    select="not(cit:CI_Responsibility/cit:party/*/cit:name)      or (cit:CI_Responsibility/cit:party/*/cit:name/@gco:nilReason)      or not(cit:CI_Responsibility/cit:party/*/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress)      or (cit:CI_Responsibility/cit:party/*/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress/@gco:nilReason)"/>
      <xsl:variable name="organisationName"
                    select="cit:CI_Responsibility/cit:party/*/cit:name/*/text()"/>
      <xsl:variable name="role"
                    select="normalize-space(cit:CI_Responsibility/cit:party/*/cit:individual/*/cit:positionName/*/text())"/>
      <xsl:variable name="emptyRole" select="$role=''"/>
      <xsl:variable name="emailAddress"
                    select="cit:CI_Responsibility/cit:party/*/cit:contactInfo/*/cit:address/*/cit:electronicMailAddress/*/text()"/>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($emptyRole)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($emptyRole)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-cit-role-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Contact role is empty.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-cit-role-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le rôle de la partie responsable est vide</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--ASSERT
      -->
<xsl:choose>
         <xsl:when test="not($missing)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                test="not($missing)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text/> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-info-failure-en">
                  <xsl:attribute name="xml:lang">en</xsl:attribute>
Organisation name and email not found metadata point of contact.</svrl:diagnostic-reference> 
               <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-info-failure-fr">
                  <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le nom et l'email du point de contact des métadonnées sont manquants</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

      <!--REPORT
      -->
<xsl:if test="not($missing)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" ref="#_{geonet:element/@ref}"
                                 test="not($missing)">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text/> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-info-success-en">
               <xsl:attribute name="xml:lang">en</xsl:attribute>
Organisation name and email found for :"<xsl:text/>
               <xsl:copy-of select="$organisationName"/>
               <xsl:text/>" ("<xsl:text/>
               <xsl:copy-of select="$role"/>
               <xsl:text/>")</svrl:diagnostic-reference> 
            <svrl:diagnostic-reference ref="#_{geonet:element/@ref}" diagnostic="rule.metadata-info-success-fr">
               <xsl:attribute name="xml:lang">fr</xsl:attribute>
Le nom et l'email du point de contact des métadonnées sont définis pour :"<xsl:text/>
               <xsl:copy-of select="$organisationName"/>
               <xsl:text/>" ("<xsl:text/>
               <xsl:copy-of select="$role"/>
               <xsl:text/>")</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
</xsl:stylesheet>