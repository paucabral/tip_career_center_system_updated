class EasyPDFError(Exception):
    """
    Base error class
    """


class UnsupportedMediaPathException(EasyPDFError):
    """
    Resource not found or unavailable
    """


class PDFRenderingError(EasyPDFError):
    def __init__(self, message, content, log, *args, **kwargs):
        super(PDFRenderingError, self).__init__(message, *args, **kwargs)
        self.content = content
        self.log = log