// Autogenerated from Pigeon (v3.2.3), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.rnd.flutter_ymodel;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
//import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Pigeon {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class YmodemRequest {
    private @Nullable Long current;
    public @Nullable Long getCurrent() { return current; }
    public void setCurrent(@Nullable Long setterArg) {
      this.current = setterArg;
    }

    private @Nullable Long total;
    public @Nullable Long getTotal() { return total; }
    public void setTotal(@Nullable Long setterArg) {
      this.total = setterArg;
    }

    private @Nullable List<Object> data;
    public @Nullable List<Object> getData() { return data; }
    public void setData(@Nullable List<Object> setterArg) {
      this.data = setterArg;
    }

    private @Nullable String msg;
    public @Nullable String getMsg() { return msg; }
    public void setMsg(@Nullable String setterArg) {
      this.msg = setterArg;
    }

    public static final class Builder {
      private @Nullable Long current;
      public @NonNull Builder setCurrent(@Nullable Long setterArg) {
        this.current = setterArg;
        return this;
      }
      private @Nullable Long total;
      public @NonNull Builder setTotal(@Nullable Long setterArg) {
        this.total = setterArg;
        return this;
      }
      private @Nullable List<Object> data;
      public @NonNull Builder setData(@Nullable List<Object> setterArg) {
        this.data = setterArg;
        return this;
      }
      private @Nullable String msg;
      public @NonNull Builder setMsg(@Nullable String setterArg) {
        this.msg = setterArg;
        return this;
      }
      public @NonNull YmodemRequest build() {
        YmodemRequest pigeonReturn = new YmodemRequest();
        pigeonReturn.setCurrent(current);
        pigeonReturn.setTotal(total);
        pigeonReturn.setData(data);
        pigeonReturn.setMsg(msg);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("current", current);
      toMapResult.put("total", total);
      toMapResult.put("data", data);
      toMapResult.put("msg", msg);
      return toMapResult;
    }
    static @NonNull YmodemRequest fromMap(@NonNull Map<String, Object> map) {
      YmodemRequest pigeonResult = new YmodemRequest();
      Object current = map.get("current");
      pigeonResult.setCurrent((current == null) ? null : ((current instanceof Integer) ? (Integer)current : (Long)current));
      Object total = map.get("total");
      pigeonResult.setTotal((total == null) ? null : ((total instanceof Integer) ? (Integer)total : (Long)total));
      Object data = map.get("data");
      pigeonResult.setData((List<Object>)data);
      Object msg = map.get("msg");
      pigeonResult.setMsg((String)msg);
      return pigeonResult;
    }
  }

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class YmodemResponse {
    private @Nullable String status;
    public @Nullable String getStatus() { return status; }
    public void setStatus(@Nullable String setterArg) {
      this.status = setterArg;
    }

    private @Nullable String operate;
    public @Nullable String getOperate() { return operate; }
    public void setOperate(@Nullable String setterArg) {
      this.operate = setterArg;
    }

    private @Nullable String filename;
    public @Nullable String getFilename() { return filename; }
    public void setFilename(@Nullable String setterArg) {
      this.filename = setterArg;
    }

    private @Nullable String filepath;
    public @Nullable String getFilepath() { return filepath; }
    public void setFilepath(@Nullable String setterArg) {
      this.filepath = setterArg;
    }

    private @Nullable Boolean stop;
    public @Nullable Boolean getStop() { return stop; }
    public void setStop(@Nullable Boolean setterArg) {
      this.stop = setterArg;
    }

    private @Nullable Boolean start;
    public @Nullable Boolean getStart() { return start; }
    public void setStart(@Nullable Boolean setterArg) {
      this.start = setterArg;
    }

    public static final class Builder {
      private @Nullable String status;
      public @NonNull Builder setStatus(@Nullable String setterArg) {
        this.status = setterArg;
        return this;
      }
      private @Nullable String operate;
      public @NonNull Builder setOperate(@Nullable String setterArg) {
        this.operate = setterArg;
        return this;
      }
      private @Nullable String filename;
      public @NonNull Builder setFilename(@Nullable String setterArg) {
        this.filename = setterArg;
        return this;
      }
      private @Nullable String filepath;
      public @NonNull Builder setFilepath(@Nullable String setterArg) {
        this.filepath = setterArg;
        return this;
      }
      private @Nullable Boolean stop;
      public @NonNull Builder setStop(@Nullable Boolean setterArg) {
        this.stop = setterArg;
        return this;
      }
      private @Nullable Boolean start;
      public @NonNull Builder setStart(@Nullable Boolean setterArg) {
        this.start = setterArg;
        return this;
      }
      public @NonNull YmodemResponse build() {
        YmodemResponse pigeonReturn = new YmodemResponse();
        pigeonReturn.setStatus(status);
        pigeonReturn.setOperate(operate);
        pigeonReturn.setFilename(filename);
        pigeonReturn.setFilepath(filepath);
        pigeonReturn.setStop(stop);
        pigeonReturn.setStart(start);
        return pigeonReturn;
      }
    }
    @NonNull Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("status", status);
      toMapResult.put("operate", operate);
      toMapResult.put("filename", filename);
      toMapResult.put("filepath", filepath);
      toMapResult.put("stop", stop);
      toMapResult.put("start", start);
      return toMapResult;
    }
    static @NonNull YmodemResponse fromMap(@NonNull Map<String, Object> map) {
      YmodemResponse pigeonResult = new YmodemResponse();
      Object status = map.get("status");
      pigeonResult.setStatus((String)status);
      Object operate = map.get("operate");
      pigeonResult.setOperate((String)operate);
      Object filename = map.get("filename");
      pigeonResult.setFilename((String)filename);
      Object filepath = map.get("filepath");
      pigeonResult.setFilepath((String)filepath);
      Object stop = map.get("stop");
      pigeonResult.setStop((Boolean)stop);
      Object start = map.get("start");
      pigeonResult.setStart((Boolean)start);
      return pigeonResult;
    }
  }
  private static class YmodemRequestApiCodec extends StandardMessageCodec {
    public static final YmodemRequestApiCodec INSTANCE = new YmodemRequestApiCodec();
    private YmodemRequestApiCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return YmodemRequest.fromMap((Map<String, Object>) readValue(buffer));
        
        case (byte)129:         
          return YmodemResponse.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof YmodemRequest) {
        stream.write(128);
        writeValue(stream, ((YmodemRequest) value).toMap());
      } else 
      if (value instanceof YmodemResponse) {
        stream.write(129);
        writeValue(stream, ((YmodemResponse) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface YmodemRequestApi {
    @NonNull YmodemRequest getMessage(@NonNull YmodemResponse params);

    /** The codec used by YmodemRequestApi. */
    static MessageCodec<Object> getCodec() {
      return YmodemRequestApiCodec.INSTANCE;
    }

    /** Sets up an instance of `YmodemRequestApi` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, YmodemRequestApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.YmodemRequestApi.getMessage", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              YmodemResponse paramsArg = (YmodemResponse)args.get(0);
              if (paramsArg == null) {
                throw new NullPointerException("paramsArg unexpectedly null.");
              }
              YmodemRequest output = api.getMessage(paramsArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}
