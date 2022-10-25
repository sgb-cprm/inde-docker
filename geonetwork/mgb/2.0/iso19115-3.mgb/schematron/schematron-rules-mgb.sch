<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	queryBinding="xslt2">

	<sch:title xmlns="http://www.w3.org/2001/XMLSchema">MGB rules</sch:title>
  <sch:title xmlns="http://www.w3.org/2001/XMLSchema" xml:lang="pt">Regras Perfil MGB</sch:title>
	<sch:ns prefix="gml" uri="http://www.opengis.net/gml"/>
	<sch:ns prefix="gmd" uri="http://standards.iso.org/iso/19115/-3/gmd"/>
  <sch:ns prefix="gmx" uri="http://standards.iso.org/iso/19115/-3/gmx"/>
	<sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
	<sch:ns prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
  <sch:ns prefix="srv" uri="http://standards.iso.org/iso/19115/-3/srv/2.0"/>
  <sch:ns prefix="mdb" uri="http://standards.iso.org/iso/19115/-3/mdb/2.0"/>
  <sch:ns prefix="mcc" uri="http://standards.iso.org/iso/19115/-3/mcc/1.0"/>
  <sch:ns prefix="mri" uri="http://standards.iso.org/iso/19115/-3/mri/1.0"/>
  <sch:ns prefix="mrs" uri="http://standards.iso.org/iso/19115/-3/mrs/1.0"/>
  <sch:ns prefix="mrd" uri="http://standards.iso.org/iso/19115/-3/mrd/1.0"/>
  <sch:ns prefix="mco" uri="http://standards.iso.org/iso/19115/-3/mco/1.0"/>
  <sch:ns prefix="msr" uri="http://standards.iso.org/iso/19115/-3/msr/2.0"/>
  <sch:ns prefix="lan" uri="http://standards.iso.org/iso/19115/-3/lan/1.0"/>
  <sch:ns prefix="gcx" uri="http://standards.iso.org/iso/19115/-3/gcx/1.0"/>
  <sch:ns prefix="gex" uri="http://standards.iso.org/iso/19115/-3/gex/1.0"/>
  <sch:ns prefix="dqm" uri="http://standards.iso.org/iso/19157/-2/dqm/1.0"/>
  <sch:ns prefix="cit" uri="http://standards.iso.org/iso/19115/-3/cit/2.0"/>
  <sch:ns prefix="mdq" uri="http://standards.iso.org/iso/19157/-2/mdq/1.0"/>
  <sch:ns prefix="mrl" uri="http://standards.iso.org/iso/19115/-3/mrl/2.0"/>
  <sch:ns prefix="gco" uri="http://standards.iso.org/iso/19115/-3/gco/1.0"/>

	<!-- MGB rules -->
  
  <!-- 1) service resource -->
  <sch:diagnostics>

    <sch:diagnostic id="rule.srv.coupledtypeandresource-failure-en"
                    xml:lang="en">If this is a tight coupled service, so at least one resource should be informed.
      Coupling type="<sch:value-of select="normalize-space($ctype)"/>",
      Resoure count=<sch:value-of select="$resCount"/>.
      </sch:diagnostic>
    
    <sch:diagnostic id="rule.srv.coupledtypeandresource-success-en"
                    xml:lang="en">Coupling type is
      "<sch:value-of select="normalize-space($ctype)"/>"
      and number of coupled resource is 
      <sch:value-of select="$resCount"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.srv.coupledtypeandresource-failure-pt"
                    xml:lang="pt">Se o serviço é fortemente acoplado, então pelo menos um recurso deve ser informado</sch:diagnostic>
    
    <sch:diagnostic id="rule.srv.coupledtypeandresource-success-pt"
                    xml:lang="pt">O tipo de acoplamento é
      "<sch:value-of select="normalize-space($ctype)"/>"
      e a quantidade de recursos acoplados é 
      "<sch:value-of select="$resCount"/>".
    </sch:diagnostic>

  </sch:diagnostics>

  <sch:pattern id="rule.srv.coupledtypeandresource">

    <sch:title xml:lang="en">Tight coupled services MUST have a coupled resource
    </sch:title>

    <sch:title xml:lang="pt">Serviços fortemente acoplados DEVEM ter recursos
    </sch:title>

    <sch:rule context="//srv:SV_ServiceIdentification[
              srv:couplingType/srv:SV_CouplingType/@codeListValue = 'tight' or
              srv:couplingType/srv:SV_CouplingType/@codeListValue = 'mixed']">

      <sch:let name="ctype" value="string(srv:couplingType/srv:SV_CouplingType/@codeListValue)"/>

      <sch:let name="resCount" value="count(srv:coupledResource/srv:SV_CoupledResource)"/>

      <sch:let name="hasResource" value="$resCount &gt; 0"/>

      <sch:assert test="$hasResource"
                  diagnostics="rule.srv.coupledtypeandresource-failure-en
                               rule.srv.coupledtypeandresource-failure-pt"/>

      <sch:report test="$hasResource"
                  diagnostics="rule.srv.coupledtypeandresource-success-en
                               rule.srv.coupledtypeandresource-success-pt"/>

    </sch:rule>

  </sch:pattern>
  <!-- fim 1) -->
  
  <!-- 2) Spatial representation for datasets -->
  <sch:diagnostics>

    <sch:diagnostic id="rule.mri.spatialrepresentationfordsandseries-failure-en"
                    xml:lang="en">A spatial representation MUST be specified for dataset or series.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.spatialrepresentationfordsandseries-failure-pt"
                    xml:lang="pt">O tipo de representação espacial DEVE ser informado para CDG e séries
    </sch:diagnostic>


    <sch:diagnostic id="rule.mri.spatialrepresentationfordsandseries-success-en"
                    xml:lang="en">Spatial representation identified:
      <sch:value-of select="$spatialRep"/>.
    </sch:diagnostic>

    <sch:diagnostic id="rule.mri.spatialrepresentationfordsandseries-success-pt"
                    xml:lang="pt">Tipo de representação espacial identificado:
      <sch:value-of select="$spatialRep"/>.
    </sch:diagnostic>

  </sch:diagnostics>
  
  <sch:pattern id="rule.mri.spatialrepresentationfordsandseries">

    <sch:title xml:lang="en">Spatial representation for dataset and series</sch:title>

    <sch:title xml:lang="pt">Tipo de representação espacial para CDG e série</sch:title>

    <sch:rule
            context="/mdb:MD_Metadata[mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/
      mcc:MD_ScopeCode/@codeListValue = 'dataset' or
      mdb:metadataScope/mdb:MD_MetadataScope/mdb:resourceScope/mcc:MD_ScopeCode/@codeListValue = 'series']/                          mdb:identificationInfo/mri:MD_DataIdentification">

      <!-- The topic category is the enumeration value and
      not the human readable one. -->

      <sch:let name="spatialRep"
               value="normalize-space(mri:spatialRepresentationType/mcc:MD_SpatialRepresentationTypeCode/@codeListValue)"/>

      <sch:let name="hasSpatialRep" value="$spatialRep != ''"/>
      
      <!-- EMX: A valid nilReason is accepted -->
      <sch:let name="hasNilReason" value="string(mri:spatialRepresentationType/@gco:nilReason) != ''"/>

      <sch:assert test="$hasSpatialRep or $hasNilReason"
                  diagnostics="rule.mri.spatialrepresentationfordsandseries-failure-en
                  rule.mri.spatialrepresentationfordsandseries-failure-pt"/>


      <sch:report test="$hasSpatialRep or $hasNilReason"
                  diagnostics="rule.mri.spatialrepresentationfordsandseries-success-en                       rule.mri.spatialrepresentationfordsandseries-success-pt"/>
    </sch:rule>

  </sch:pattern>
  <!-- fim 2) -->
  

</sch:schema>
