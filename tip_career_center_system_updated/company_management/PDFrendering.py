from django.conf import settings
from django.template import loader
from django.http import HttpResponse
from django.utils.http import urlquote
from django.utils.six import BytesIO
from xhtml2pdf import pisa
from .PDFexceptions import UnsupportedMediaPathException, PDFRenderingError
import logging, os, xhtml2pdf.default

logger = logging.getLogger("app.pdf")
logger_x2p = logging.getLogger("app.pdf.xhtml2pdf")

def fetch_resources(uri, rel):
    print(os.path.join(settings.MEDIA_ROOT, (uri.replace(settings.STATIC_URL, "")).replace("/", "\\")))
    return os.path.join(settings.MEDIA_ROOT, (uri.replace(settings.STATIC_URL, "")).replace("/", "\\"))

def html_to_pdf(content, link_callback=fetch_resources, **kwargs):
    src = BytesIO(content.encode("UTF-8"))
    dest = BytesIO()
    pdf = pisa.pisaDocument(src, dest, encoding="utf-8", link_callback=link_callback, **kwargs)
    if pdf.err:
        logger.error("Error rendering PDF document")
        for entry in pdf.log:
            if entry[0] == xhtml2pdf.default.PML_ERROR:
                logger_x2p.error("line %s, msg: %s, fragment: %s", entry[1], entry[2], entry[3])
        raise PDFRenderingError("Errors rendering PDF", content=content, log=pdf.log)

    if pdf.warn:
        for entry in pdf.log:
            if entry[0] == xhtml2pdf.default.PML_WARNING:
                logger_x2p.warning("line %s, msg: %s, fragment: %s", entry[1], entry[2], entry[3])

    return dest.getvalue()

def encode_filename(filename):
    quoted = urlquote(filename)
    if quoted == filename:
        return "filename=%s" % filename
    else:
        return "filename*=UTF-8''%s" % quoted

def make_response(content, filename=None):
    response = HttpResponse(content, content_type="application/pdf")
    if filename is not None:
        response["Content-Disposition"] = "attachment; %s" % encode_filename(filename)
    return response

def render_to_pdf(template, context, using=None, request=None, encoding="utf-8", **kwargs):
    content = loader.render_to_string(template, context, request=request, using=using)
    return html_to_pdf(content, **kwargs)

def render_to_pdf_response(request, template, context, using=None, filename=None, encoding="utf-8", **kwargs):
    try:
        pdf = render_to_pdf(template, context, using=using, encoding=encoding, **kwargs)
        return make_response(pdf, filename)
    except PDFRenderingError as e:
        logger.exception(e.message)
        return HttpResponse(e.message)
