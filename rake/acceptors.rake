namespace :acceptor do
  ACCEPTOR_DIR = "#{SRC_DIR}/acceptor"
  ACCEPTOR_OBJ = "#{OBJ_DIR}/acceptor.a"
  ACCEPTOR_SRC = "#{OBJ_DIR}/acceptor.fst"
  ACCEPTOR_EACH_SRC = FileList["#{ACCEPTOR_DIR}/*.fst"]
  ACCEPTOR_EACH_OBJ = ACCEPTOR_EACH_SRC.ext("a")

  CLEAN.include(ACCEPTOR_SRC)
  CLEAN.include(ACCEPTOR_EACH_OBJ)
  CLOBBER.include(ACCEPTOR_OBJ)

  rule ".a" => ".fst" do |t|
    sh "fst-compiler #{t.source} #{t.name}"
  end

  multitask ACCEPTOR_SRC => ACCEPTOR_EACH_OBJ do
    out = File.open(ACCEPTOR_SRC, "w")
    first_line = true
    ACCEPTOR_EACH_OBJ.each do |obj|
      puts obj
      if first_line then first_line = false else out.puts " |\\\n" end
      out.puts("<#{obj}>")
    end
    out.close
  end


  task ACCEPTOR_OBJ => ACCEPTOR_SRC do
    puts "Building acceptor..."
    sh "fst-compiler #{ACCEPTOR_SRC} #{ACCEPTOR_OBJ}"
  end

  desc "Build the acceptor (grammar) FST."
  task :default => ACCEPTOR_OBJ

end
