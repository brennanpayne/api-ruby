module Normalizers
  def url(value):
      value.to_s[/^(https?:\/\/)[-\w.~]+(:\d+)?(\/[-\w.~]+)*/]
  end
end
def normalize(value, normalizer):
    Normalizers.send(normalizer)
end
