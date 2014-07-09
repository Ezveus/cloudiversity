class Attachment < ActiveRecord::Base
    PermittedParams = [ :id, :file, :_destroy ]
    belongs_to :attachable, polymorphic: true
    mount_uploader :file, FileUploader

    def filename
        file.path.split('/').last if file.path
    end

    def icon
        ext = file.path.split('.').last if file.path

        'icons/32px/' + ext_img(ext)
    end

    private

    Extensions = [ 'aac',
                   'aiff',
                   'ai',
                   'avi',
                   'bmp',
                   'c',
                   'cpp',
                   'css',
                   'dat',
                   'dmg',
                   'doc',
                   'dotx',
                   'dwg',
                   'dxf',
                   'eps',
                   'exe',
                   'flv',
                   'gif',
                   'h',
                   'hpp',
                   'html',
                   'ics',
                   'iso',
                   'java',
                   'jpg',
                   'js',
                   'key',
                   'less',
                   'mid',
                   'mp3',
                   'mp4',
                   'mpg',
                   'odf',
                   'ods',
                   'odt',
                   'otp',
                   'ots',
                   'ott',
                   'pdf',
                   'php',
                   'png',
                   'ppt',
                   'psd',
                   'py',
                   'qt',
                   'rar',
                   'rb',
                   'rtf',
                   'sass',
                   'scss',
                   'sql',
                   'tga',
                   'tgz',
                   'tiff',
                   'txt',
                   'wav',
                   'xls',
                   'xlsx',
                   'xml',
                   'yml',
                   'zip'
                 ]

    def ext_img(ext)
        if Extensions.include? ext
            "#{ext}.png"
        elsif ext == 'jpeg'
            'jpg.png'
        else
            '_blank.png'
        end
    end
end
