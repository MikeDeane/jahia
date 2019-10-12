<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
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
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title>${fn:escapeXml(renderContext.mainResource.node.displayableName)}</title>
  
    <template:addResources type="css" resources="flexslider.css" />
    <template:addResources type="css" resources="font-awesome.css" />
    <template:addResources type="css" resources="jquery.bxslider.css" />
    <template:addResources type="css" resources="jquery.fancybox.css" />
    <template:addResources type="css" resources="portfolio-v1.css" />
    <template:addResources type="css" resources="responsive.css" />
    <template:addResources type="css" resources="screen.css" />
  
  <link rel="shortcut icon" href="${url.currentModule}img/favicon.ico">

  
</head>

<body>


    <template:area path="pagecontent"/>

    <template:addResources type="javascript" resources="hover-dropdown.min.js" />
    <template:addResources type="javascript" resources="jquery-1.10.2.min.js" />
    <template:addResources type="javascript" resources="jquery.bxslider.js" />
    <template:addResources type="javascript" resources="jquery.fancybox.pack.js" />
    <template:addResources type="javascript" resources="jquery.flexslider-min.js" />
    <template:addResources type="javascript" resources="jquery-migrate-1.4.1.min.js" />
    <template:addResources type="javascript" resources="bootstrap.min.js" />
  
    <template:addResources type="javascript" resources="app.js" />
  
    <script type="text/javascript">
        jQuery(document).ready(function() {
            App.init();
            App.initSliders();
            App.initFancybox();
            App.initBxSlider();
        });
    </script>
  
    <template:addResources type="javascript" resources="respond.js" condition="if lt IE 9"/>
  
  	

</body>
</html>
