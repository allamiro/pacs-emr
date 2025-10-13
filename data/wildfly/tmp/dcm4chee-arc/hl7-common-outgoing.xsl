<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="MSH">
        <xsl:param name="sender" />
        <xsl:param name="receiver" />
        <xsl:param name="dateTime" />
        <xsl:param name="msgType" />
        <xsl:param name="msgControlID" />
        <xsl:param name="charset" />
        <MSH fieldDelimiter="|" componentDelimiter="^" repeatDelimiter="~" escapeDelimiter="\" subcomponentDelimiter="&amp;">
            <field>
                <xsl:value-of select="substring-before($sender, '|')" />
            </field>
            <field>
                <xsl:value-of select="substring-after($sender, '|')" />
            </field>
            <field>
                <xsl:value-of select="substring-before($receiver, '|')" />
            </field>
            <field>
                <xsl:value-of select="substring-after($receiver, '|')" />
            </field>
            <field>
                <xsl:value-of select="$dateTime" />
            </field>
            <field/>
            <field>
                <xsl:value-of select="substring($msgType, 1, 3)" />
                <component>
                    <xsl:value-of select="substring($msgType, 5, 3)" />
                </component>
                <component>
                    <xsl:value-of select="substring($msgType, 9, 7)" />
                </component>
            </field>
            <field>
                <xsl:value-of select="$msgControlID" />
            </field>
            <field>P</field>
            <field>2.5.1</field>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field>
                <xsl:if test="$charset != 'ASCII'">
                    <xsl:value-of select="$charset"/>
                </xsl:if>
            </field>
        </MSH>
    </xsl:template>

    <xsl:template name="PID">
        <xsl:param name="patientIdentifiers" />
        <xsl:param name="includeNullValues" />
        <PID>
            <field/>
            <field/>
            <field>
                <xsl:call-template name="patientIdentifier">
                    <xsl:with-param name="cx" select="$patientIdentifiers"/>
                    <xsl:with-param name="includeNullValues" select="$includeNullValues"/>
                    <xsl:with-param name="repeat" select="'N'"/>
                </xsl:call-template>
            </field>
            <field/>
            <field>
                <xsl:call-template name="personName">
                    <xsl:with-param name="tag" select="'00100010'" />
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
            </field>
            <field>
                <xsl:call-template name="personName">
                    <xsl:with-param name="tag" select="'00101060'" />
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
            </field>
            <field>
                <xsl:call-template name="attr">
                    <xsl:with-param name="tag" select="'00100030'" />
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
            </field>
            <field>
                <xsl:call-template name="attr">
                    <xsl:with-param name="tag" select="'00100040'" />
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
                <xsl:call-template name="neutered">
                    <xsl:with-param name="tag" select="'00102203'" />
                </xsl:call-template>
            </field>
            <field>
                <xsl:call-template name="personName">
                    <xsl:with-param name="tag" select="'00102297'" />
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
            </field>
            <field/>
            <field>
                <xsl:call-template name="address">
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
            </field>
            <field/>
            <field/>
            <field/>
            <field>
                <xsl:call-template name="codeItem">
                    <xsl:with-param name="item" select="DicomAttribute[@tag='00100101']/Item"/>
                </xsl:call-template>
            </field>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field>
                <xsl:call-template name="militaryRank">
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
            </field>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field/>
            <field>
                <xsl:call-template name="ce2codeItemWithDesc">
                    <xsl:with-param name="descTag" select="'00102201'" />
                    <xsl:with-param name="sqTag" select="'00102202'" />
                </xsl:call-template>
            </field>
            <field>
                <xsl:call-template name="ce2codeItemWithDesc">
                    <xsl:with-param name="descTag" select="'00102292'" />
                    <xsl:with-param name="sqTag" select="'00102293'" />
                </xsl:call-template>
            </field>
        </PID>
    </xsl:template>

    <xsl:template name="militaryRank">
        <xsl:param name="includeNullValues"/>
        <xsl:variable name="militaryRankVal" select="DicomAttribute[@tag='00101040']/Value" />
        <xsl:choose>
            <xsl:when test="$militaryRankVal">
                <component>
                    <xsl:value-of select="$militaryRankVal"/>
                </component>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$includeNullValues" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nte-pid">
        <NTE>
            <field/>
            <field/>
            <field>
                <xsl:call-template name="attr">
                    <xsl:with-param name="tag" select="'00104000'" />
                    <xsl:with-param name="includeNullValues" select="$includeNullValues" />
                </xsl:call-template>
            </field>
            <field/>
        </NTE>
    </xsl:template>

    <xsl:template name="address">
        <xsl:param name="includeNullValues"/>
        <xsl:variable name="address" select="DicomAttribute[@tag='00101040']" />
        <xsl:choose>
            <xsl:when test="$address">
                <xsl:if test="contains($address, '^')">
                    <xsl:variable name="streetAddr" select="substring-before($address, '^')"/>
                    <xsl:value-of select="$streetAddr"/>
                    <xsl:call-template name="addressComp">
                        <xsl:with-param name="addrComp" select="substring-after($address, '^')"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$includeNullValues" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="addressComp">
        <xsl:param name="addrComp"/>
        <xsl:choose>
            <xsl:when test="not(contains($addrComp, '^')) and string-length($addrComp) > 0">
                <component>
                    <xsl:value-of select="$addrComp"/>
                </component>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($addrComp, '^')">
                        <component/>
                        <xsl:choose>
                            <xsl:when test="string-length($addrComp) > 1">
                                <xsl:call-template name="addressComp">
                                    <xsl:with-param name="addrComp" select="substring-after($addrComp, '^')"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <component/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="comp" select="substring-before($addrComp, '^')"/>
                        <component>
                            <xsl:value-of select="$comp"/>
                        </component>
                        <xsl:call-template name="addressComp">
                            <xsl:with-param name="addrComp" select="substring-after($addrComp, '^')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="attr">
        <xsl:param name="tag"/>
        <xsl:param name="includeNullValues" />
        <xsl:variable name="val" select="DicomAttribute[@tag=$tag]/Value"/>
        <xsl:call-template name="attrVal">
            <xsl:with-param name="val" select="$val"/>
            <xsl:with-param name="includeNullValues" select="$includeNullValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="attrVal">
        <xsl:param name="val"/>
        <xsl:param name="includeNullValues" />
        <xsl:choose>
            <xsl:when test="$val">
                <xsl:value-of select="$val"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$includeNullValues" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="personName">
        <xsl:param name="tag" />
        <xsl:param name="includeNullValues" />
        <xsl:variable name="name" select="DicomAttribute[@tag=$tag]/PersonName[1]/Alphabetic" />
        <xsl:choose>
            <xsl:when test="$name">
                <xsl:call-template name="pnComponent">
                    <xsl:with-param name="name" select="$name"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$includeNullValues" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pnComponent">
        <xsl:param name="name"/>
        <xsl:value-of select="$name/FamilyName" />
        <component>
            <xsl:value-of select="$name/GivenName" />
        </component>
        <component>
            <xsl:value-of select="$name/MiddleName" />
        </component>
        <xsl:variable name="ns" select="$name/NameSuffix" />
        <component>
            <xsl:choose>
                <xsl:when test="contains($ns, ' ')">
                    <xsl:value-of select="substring-before($ns, ' ')" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ns" />
                </xsl:otherwise>
            </xsl:choose>
        </component>
        <component>
            <xsl:value-of select="$name/NamePrefix" />
        </component>
        <component>
            <xsl:value-of select="substring-after($ns, ' ')" />
        </component>
    </xsl:template>

    <xsl:template name="neutered">
        <xsl:param name="tag"/>
        <xsl:variable name="val" select="DicomAttribute[@tag=$tag]/Value"/>
        <xsl:if test="$val">
            <component>
                <xsl:choose>
                    <xsl:when test="$val = 'ALTERED'">Y</xsl:when>
                    <xsl:otherwise>N</xsl:otherwise>
                </xsl:choose>
            </component>
        </xsl:if>
    </xsl:template>

    <xsl:template name="ce2codeItemWithDesc">
        <xsl:param name="descTag" />
        <xsl:param name="sqTag" />
        <xsl:call-template name="codeOrDesc">
            <xsl:with-param name="item" select="DicomAttribute[@tag=$sqTag]/Item" />
            <xsl:with-param name="desc" select="DicomAttribute[@tag=$descTag]/Value" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="codeOrDesc">
        <xsl:param name="item"/>
        <xsl:param name="desc"/>
        <xsl:choose>
            <xsl:when test="$item">
                <xsl:call-template name="codeItem">
                    <xsl:with-param name="item" select="$item"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$desc">
                <component>
                    <xsl:value-of select="$desc"/>
                </component>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="codeItem">
        <xsl:param name="item"/>
        <xsl:value-of select="$item/DicomAttribute[@tag='00080100']/Value" />
        <component>
            <xsl:value-of select="$item/DicomAttribute[@tag='00080104']/Value" />
        </component>
        <component>
            <xsl:value-of select="$item/DicomAttribute[@tag='00080102']/Value" />
        </component>
    </xsl:template>

    <xsl:template name="patientIdentifier">
        <xsl:param name="cx"/>
        <xsl:param name="includeNullValues"/>
        <xsl:param name="repeat"/>
        <xsl:choose>
            <xsl:when test="contains($cx, '~')">
                <xsl:variable name="cx1" select="substring-before($cx, '~')"/>
                <xsl:variable name="cxRemaining" select="substring-after($cx, '~')"/>
                <xsl:call-template name="patientIdentifierComp">
                    <xsl:with-param name="patientIdentifier" select="$cx1"/>
                    <xsl:with-param name="includeNullValues" select="$includeNullValues"/>
                    <xsl:with-param name="repeat" select="$repeat"/>
                </xsl:call-template>
                <xsl:call-template name="patientIdentifier">
                    <xsl:with-param name="cx" select="$cxRemaining"/>
                    <xsl:with-param name="includeNullValues" select="$includeNullValues"/>
                    <xsl:with-param name="repeat" select="'Y'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="patientIdentifierComp">
                    <xsl:with-param name="patientIdentifier" select="$cx"/>
                    <xsl:with-param name="includeNullValues" select="$includeNullValues"/>
                    <xsl:with-param name="repeat" select="$repeat"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="patientIdentifierComp">
        <xsl:param name="patientIdentifier"/>
        <xsl:param name="includeNullValues"/>
        <xsl:param name="repeat"/>
        <xsl:choose>
            <xsl:when test="string-length($patientIdentifier) > 0">
                <xsl:choose>
                    <xsl:when test="$repeat = 'Y'">
                        <repeat>
                            <xsl:call-template name="addPatientIdentifier">
                                <xsl:with-param name="patientIdentifier" select="$patientIdentifier"/>
                            </xsl:call-template>
                        </repeat>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="addPatientIdentifier">
                            <xsl:with-param name="patientIdentifier" select="$patientIdentifier"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$includeNullValues" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="addPatientIdentifier">
        <xsl:param name="patientIdentifier"/>
        <xsl:choose>
            <xsl:when test="contains($patientIdentifier, '^^^')">
                <xsl:variable name="patientID" select="substring-before($patientIdentifier, '^^^')"/>
                <xsl:variable name="issuer" select="substring-after($patientIdentifier, '^^^')"/>
                <xsl:value-of select="$patientID"/>
                <component/><component/>
                <component>
                    <xsl:choose>
                        <xsl:when test="contains($issuer, '&amp;')">
                            <xsl:variable name="issuerOfPatientID" select="substring-before($issuer, '&amp;')"/>
                            <xsl:variable name="issuerOfPIDQualifier" select="substring-after($issuer, '&amp;')"/>
                            <xsl:variable name="universalEntityID" select="substring-before($issuerOfPIDQualifier, '&amp;')"/>
                            <xsl:variable name="universalEntityIDType" select="substring-after($issuerOfPIDQualifier, '&amp;')"/>
                            <xsl:value-of select="$issuerOfPatientID"/>
                            <subcomponent>
                                <xsl:value-of select="$universalEntityID"/>
                            </subcomponent>
                            <subcomponent>
                                <xsl:value-of select="$universalEntityIDType"/>
                            </subcomponent>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$issuer"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </component>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$patientIdentifier"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
