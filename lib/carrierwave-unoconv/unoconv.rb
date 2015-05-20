module CarrierWave
  module UNOConv
    extend ActiveSupport::Concern
    module ClassMethods
      def uno_convert(format, opts={})
        process uno_convert: [format, opts]
      end
    end

    def uno_convert(format, opts={})
      directory = File.dirname( current_path )
      tmpfile   = File.join( directory, "tmpfile" )

      filter_options = opts[:filter_options]
      filter_options = "-e FilterOptions=#{filter_options}" unless filter_options.blank?

      File.rename( current_path, tmpfile )

      raise CarrierWave::ProcessingError, "UNOconv failed." unless system "unoconv -f #{format} #{filter_options} '#{tmpfile}'"

      File.rename( File.join(directory, "tmpfile.#{format}"), current_path )

      File.delete( tmpfile )
    end
  end
end
