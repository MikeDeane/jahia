<%@ page language="java" contentType="text/html;charset=UTF-8" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>

<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<template:addResources type="css" resources="searchresults.css"/>
<template:addResources type="css" resources="pages/page_search_inner.css"/>

<c:if test="${renderContext.editMode}">
    <fieldset>
    <legend>${fn:escapeXml(jcr:label(currentNode.primaryNodeType,currentResource.locale))}</legend>
</c:if>
<c:set var="hitsName" value="hits_${currentNode.identifier}"/>
<c:set var="hitsCountName" value="hitsCount_${currentNode.identifier}"/>
<c:choose>
    <c:when test='${searchMap[hitsName] eq null}'>
        <s:results var="resultsHits" approxCountVar="listApproxSize">
            <c:set target="${moduleMap}" property="listTotalSize" value="${count}"/>
            <c:set target="${moduleMap}" property="resultsHits" value="${resultsHits}"/>
            <c:set target="${moduleMap}" property="listApproxSize" value="${listApproxSize}"/>
            <c:if test='${searchMap == null}'>
                <jsp:useBean id="searchMap" class="java.util.HashMap" scope="request"/>
            </c:if>
            <c:set target="${searchMap}" property="${hitsName}" value="${resultsHits}"/>
            <c:set target="${searchMap}" property="${hitsCountName}" value="${count}"/>
            <c:set target="${searchMap}" property="listApproxSize" value="${listApproxSize}"/>
        </s:results>
    </c:when>
    <c:otherwise>
        <c:set target="${moduleMap}" property="listTotalSize" value="${searchMap[hitsCountName]}"/>
        <c:set target="${moduleMap}" property="resultsHits" value="${searchMap[hitsName]}"/>
        <c:set target="${moduleMap}" property="listApproxSize" value="${searchMap[listApproxSize]}"/>
    </c:otherwise>
</c:choose>

<jcr:nodeProperty name="jcr:title" node="${currentNode}" var="title"/>
<jcr:nodeProperty name="autoSuggest" node="${currentNode}" var="autoSuggest"/>
<div id="${currentNode.UUID}">
    <div class="s-results">
        <c:if test="${param.autoSuggest != false && autoSuggest.boolean && (empty moduleMap || empty moduleMap.begin || moduleMap.begin == 0)}">
            <%-- spelling auto suggestions are enabled --%>
            <jcr:nodeProperty name="autoSuggestMinimumHitCount" node="${currentNode}" var="autoSuggestMinimumHitCount"/>
            <jcr:nodeProperty name="autoSuggestHitCount" node="${currentNode}" var="autoSuggestHitCount"/>
            <jcr:nodeProperty name="autoSuggestMaxTermCount" node="${currentNode}" var="autoSuggestMaxTermCount"/>
            <c:if test="${moduleMap['listTotalSize'] <= functions:default(autoSuggestMinimumHitCount.long, 2)}">
                <%-- the number of original results is less than the configured threshold, we can start auto-suggest  --%>
                <s:suggestions runQuery="${autoSuggestHitCount.long > 0}"
                               maxTermsToSuggest="${autoSuggestMaxTermCount.long}">
                    <%-- we have a suggestion --%>
                    <c:if test="${autoSuggestHitCount.long > 0 && suggestedCount > moduleMap['listTotalSize']}">
                        <%-- found more hits for the suggestion than the original query brings --%>
                        <h4>
                            <fmt:message key="search.results.didYouMean"/>:&nbsp;
                            <c:forEach var="suggestion" items="${suggestion.allSuggestions}" varStatus="status">
                                <a href="<s:suggestedSearchUrl suggestion="${suggestion}"/>"><em>${fn:escapeXml(suggestion)}</em></a>
                                <c:if test="${not status.last}">, </c:if>
                            </c:forEach>
                            <br/><fmt:message key="search.results.didYouMean.topResults"><fmt:param
                                value="${functions:min(functions:default(autoSuggestHitCount.long, 2), suggestedCount)}"/></fmt:message>
                        </h4>
                        <ol>
                            <s:resultIterator begin="0" end="${functions:default(autoSuggestHitCount.long, 2) - 1}">
                                <li>
                                    <%@ include file="searchHit.jspf" %>
                                </li>
                            </s:resultIterator>
                        </ol>
                        <hr/>
                        <h4><fmt:message
                                key="search.results.didYouMean.resultsFor"/>:&nbsp;<strong>${fn:escapeXml(suggestion.originalQuery)}</strong>
                        </h4>
                    </c:if>
                    <c:if test="${autoSuggestHitCount.long == 0}">
                        <h4>
                            <fmt:message key="search.results.didYouMean"/>:&nbsp;
                            <c:forEach var="suggestion" items="${suggestion.allSuggestions}" varStatus="status">
                                <a href="<s:suggestedSearchUrl suggestion="${suggestion}"/>"><em>${fn:escapeXml(suggestion)}</em></a>
                                <c:if test="${not status.last}">, </c:if>
                            </c:forEach>
                        </h4>
                    </c:if>
                </s:suggestions>
            </c:if>
        </c:if>
        <c:if test="${searchMap['listApproxSize'] > 0 || moduleMap['listTotalSize'] > 0}">
            <c:set var="termKey" value="src_terms[0].term"/>
            <c:if test="${searchMap['listApproxSize'] eq 2147483647 || (searchMap['listApproxSize'] eq 0 && moduleMap['listTotalSize'] eq 2147483647)}">
                <span class="results-number"><fmt:message key="search.results.sizeNotExact.found"><fmt:param
                        value="${fn:escapeXml(param[termKey])}"/><fmt:param value="more"/></fmt:message></span>
            </c:if>
            <c:if test="${searchMap['listApproxSize'] > 0 && searchMap['listApproxSize'] < 2147483647 || moduleMap['listTotalSize'] < 2147483647}">
                <c:set var="messKey" value="search.results.found"/>
                <c:if test="${searchMap['listApproxSize'] > 0}">
                    <c:set var="messKey" value="search.results.sizeNotExact.found"/>
                </c:if>
                <span class="results-number"><fmt:message key="${messKey}"><fmt:param
                        value="${fn:escapeXml(param[termKey])}"/><fmt:param
                        value="${searchMap['listApproxSize'] > 0 ? searchMap['listApproxSize'] : moduleMap['listTotalSize']}"/></fmt:message></span>
            </c:if>
            <c:set var="beginName" value="begin_${currentNode.identifier}"/>
            <c:set var="endName" value="end_${currentNode.identifier}"/>
            <c:if test="${not empty requestScope[beginName]}">
                <c:set target="${moduleMap}" property="begin" value="${requestScope[beginName]}"/>
            </c:if>
            <c:if test="${not empty requestScope[endName]}">
                <c:set target="${moduleMap}" property="end" value="${requestScope[endName]}"/>
            </c:if>
            <ol start="${moduleMap.begin+1}">
                <s:resultIterator begin="${moduleMap.begin}" end="${moduleMap.end}" varStatus="status"
                                  hits="${moduleMap['resultsHits']}">
                    <li><%--<span>${status.index+1}.</span>--%><%@ include file="searchHit.jspf" %></li>
                </s:resultIterator>
            </ol>
            <div class="clear"></div>
        </c:if>
        <c:if test="${moduleMap['listTotalSize'] == 0}">
            <h4><fmt:message key="search.results.no.results"/></h4>
        </c:if>
    </div>
</div>

<c:if test="${renderContext.editMode}">
    </fieldset>
</c:if>