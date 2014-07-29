namespace :macs do
  desc "carga las macs antiguas"
  task load: :environment do
    f = open("#{Rails.root}/lib/tasks/macs_raw.txt")
    nodo1 = User.where(email: '2hw-nodo-1@2hw.es').first
    nodo2 = User.where(email: '2hw-nodo-2@2hw.es').first
    nodo3 = User.where(email: '2hw-vijaldoso@2hw.es').first
    vacio = User.where(email: 'vacio@2hw.es').first

    f.read.each_line do |line|
      split = line.split(';')
      mac = split[0].strip
      nodo_str = split[1].downcase.strip
      comment = split[2].strip

      mac = Mac.new(mac: mac)
      mac.comment = comment
      case nodo_str
        when "2hw-nodo-1"
          mac.user = nodo1

        when "2hw-nodo-2"
          mac.user = nodo2

        when "2hw-vijaldoso"
          mac.user = nodo3

        else
          mac.user = vacio
      end
      mac.save
    end
  end

  desc "Carga las macs de sanhilario"
  task load_sanhilario: :environment do
    f = open("#{Rails.root}/lib/tasks/macs_sanhilario.txt")
    sanhilario = User.where(email: 'sanhilario@2hw.es').first

    f.read.each_line do |line|
      split = line.split(';')
      mac = split[0].strip
      nodo_str = split[1].downcase.strip
      comment = split[2].strip

      mac = Mac.new(mac: mac)
      mac.comment = comment
      mac.user = sanhilario
      mac.save
    end
  end
end
